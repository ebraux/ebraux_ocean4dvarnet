import unittest
import torch
from ocean4dvarnet.utils import cosanneal_lr_adam

class MockLitMod:
    class Solver:
        def __init__(self):
            self.grad_mod = torch.nn.Linear(10, 10)
            self.obs_cost = torch.nn.Linear(10, 10)
            self.prior_cost = torch.nn.Linear(10, 10)
    
    def __init__(self):
        self.solver = self.Solver()

class TestCosannealLrAdam(unittest.TestCase):
    def setUp(self):
        self.lit_mod = MockLitMod()
        self.lr = 0.001
        self.T_max = 100
        self.weight_decay = 0.01

    def test_optimizer_parameters(self):
        result = cosanneal_lr_adam(self.lit_mod, self.lr, self.T_max, self.weight_decay)
        optimizer = result['optimizer']
        self.assertEqual(len(optimizer.param_groups), 3)
        self.assertAlmostEqual(optimizer.param_groups[0]['lr'], self.lr)
        self.assertAlmostEqual(optimizer.param_groups[1]['lr'], self.lr)
        self.assertAlmostEqual(optimizer.param_groups[2]['lr'], self.lr / 2)
        self.assertAlmostEqual(optimizer.defaults['weight_decay'], self.weight_decay)

    def test_lr_scheduler(self):
        result = cosanneal_lr_adam(self.lit_mod, self.lr, self.T_max, self.weight_decay)
        lr_scheduler = result['lr_scheduler']
        self.assertIsInstance(lr_scheduler, torch.optim.lr_scheduler.CosineAnnealingLR)
        self.assertEqual(lr_scheduler.T_max, self.T_max)

if __name__ == '__main__':
    unittest.main()