"""Test python environment"""

import torch
import numpy as np


def test_pytorch():
    """
    Test the availability and basic functionality of PyTorch.

    - Check if PyTorch is installed and display its version.
    - Create a simple tensor to confirm that PyTorch is working.
    - Check if CUDA is available for GPU computation.
    - Test the conversion of a NumPy array to a PyTorch tensor.
    """
    print("PyTorch est disponible!")
    print(f"Version de PyTorch: {torch.__version__}")

    # Test de création d'un tensor basique
    test_tensor = torch.tensor([1, 2, 3])
    print(f"Tensor test créé avec succès: {test_tensor}")
    print(f"Type du tensor: {type(test_tensor)}")

    # Vérifier si CUDA est disponible
    if torch.cuda.is_available():
        print("CUDA est disponible!")
        print(f"Nombre de GPUs disponibles: {torch.cuda.device_count()}")
        print(f"Nom du GPU: {torch.cuda.get_device_name(0)}")
    else:
        print("CUDA n'est pas disponible, PyTorch utilise le CPU.")

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

# Appel de la fonction pour tester
# test_pytorch()


def test_numpy():
    """
    Test the availability and basic functionality of NumPy.

    1. Try to import NumPy.
    2. Check its version.
    3. Attempt to create a simple array to confirm that NumPy is working correctly.

    If NumPy is not installed or there is an issue with the installation, 
    the script will display an appropriate error message.
    """
    try:
        print("NumPy est disponible!")
        print(f"Version de NumPy: {np.__version__}")

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

# Appel de la fonction pour tester
# test_numpy()
