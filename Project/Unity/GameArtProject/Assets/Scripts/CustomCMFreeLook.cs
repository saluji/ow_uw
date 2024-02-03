using UnityEngine;
using Cinemachine;

/// <summary>
/// Erweitert das Standardverhalten der FreeLook Cinemachine Kamera
/// so das sich diese nur beim Halten einer Maustaste bewegt
/// </summary>
public class CustomCMFreeLook : MonoBehaviour
{
    /// <summary>
    /// Definiert den Mausbutton der gedrückt werden muss
    /// damit die Kamera rotiert
    /// -1 = Kein Mausbutton / 0 = linke Maustaste / 
    /// 1 = rechte Maustaste / 2 = mittlere Maustaste
    /// </summary>
    [Range(-1, 2)]
    public int mouseButtonIndex = 0;

    void Start()
    {
        // Standard-Funktion mittels Delegat überschreiben
        // (Eigene Methode wird aufgerufen)
        CinemachineCore.GetInputAxis = GetAxisCustom;
    }

    /// <summary>
    /// Methode welche das Standardverhalten überschreibt
    /// </summary>
    /// <param name="axisName"></param>
    /// <returns></returns>
    public float GetAxisCustom(string axisName)
    {
        // Mouse button = -1 > Disable the logic
        if (mouseButtonIndex == -1)
        {
            return Input.GetAxis(axisName);
        }

        if (axisName == "Mouse X")
        {
            if (Input.GetMouseButton(mouseButtonIndex))
            {
                return Input.GetAxis("Mouse X");
            }
            else
            {
                return 0;
            }
        }
        else if (axisName == "Mouse Y")
        {
            if (Input.GetMouseButton(mouseButtonIndex))
            {
                return Input.GetAxis("Mouse Y");
            }
            else
            {
                return 0;
            }
        }
        return Input.GetAxis(axisName);
    }
}
