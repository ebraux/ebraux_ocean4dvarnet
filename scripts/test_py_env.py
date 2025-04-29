"""Test python environment"""

import torch
import numpy as np


def test_pytorch_version():
    """Test if PyTorch is installed and display its version."""
    try:
        print("PyTorch is available!")
        print(f"PyTorch version: {torch.__version__}")
    except ImportError:
        print("PyTorch is NOT available.")

def test_cuda_gpu():
    """
    Check if CUDA is available for GPU computation.
    """
    # Vérifier si CUDA est disponible
    if torch.cuda.is_available():
        print("CUDA is available!")
        print(f"Number of available de GPUs: {torch.cuda.device_count()}")
        print(f"GPU name: {torch.cuda.get_device_name(0)}")
    else:
        print("CUDA n'est pas disponible, PyTorch utilise le CPU.")


def test_pytorch_tensor():
    """
    Create a simple tensor to confirm that PyTorch is working.
    """
    # Test de création d'un tensor basique
    test_tensor = torch.tensor([1, 2, 3])
    print(f"Tensor test créé avec succès: {test_tensor}")
    print(f"Type du tensor: {type(test_tensor)}")

def test_pytorch_numpy():
    """Test the conversion of a NumPy array to a PyTorch tensor"""

    # Test de la conversion numpy -> pytorch
    try:
        numpy_array = np.array([4, 5, 6])
        tensor_from_numpy = torch.from_numpy(numpy_array)
        print(f"Conversion NumPy vers PyTorch réussie: {tensor_from_numpy}")
    except TypeError as e:
        print(f"Erreur de type lors de la conversion NumPy vers PyTorch: {str(e)}")
    except ValueError as e:
        print(f"Erreur de valeur lors de la conversion NumPy vers PyTorch: {str(e)}")
    except RuntimeError as e:
        print(f"Erreur d'exécution lors de la conversion NumPy vers PyTorch: {str(e)}")
    except ImportError:
        print("PyTorch n'est pas disponible dans cet environnement.")


def test_numpy_version():
    """Test if NumPy is installed and display its version."""
    try:
        print("NumPy est disponible!")
        print(f"Version de NumPy: {np.__version__}")

    except ImportError:
        print("NumPy n'est pas disponible dans cet environnement.")


def test_numpy_array():
    """
    Test basic functionality of NumPy.
     Attempt to create a simple array to confirm that NumPy is working correctly.
    If NumPy is not installed or there is an issue with the installation, 
    the script will display an appropriate error message.
    """
    try:
        # Test de création d'un tableau basique
        test_array = np.array([1, 2, 3])
        print(f"Tableau test créé avec succès: {test_array}")
        print(f"Type du tableau: {type(test_array)}")

    except ImportError:
        print("NumPy n'est pas disponible dans cet environnement.")
    except TypeError as e:
        print(f"Erreur de type lors de l'utilisation de NumPy: {str(e)}")
    except ValueError as e:
        print(f"Erreur de valeur lors de l'utilisation de NumPy: {str(e)}")
    except RuntimeError as e:
        print(f"Erreur d'exécution lors de l'utilisation de NumPy: {str(e)}")


test_pytorch_version()
test_numpy_version()
test_cuda_gpu()
test_pytorch_tensor()
test_pytorch_numpy()
test_numpy_array()