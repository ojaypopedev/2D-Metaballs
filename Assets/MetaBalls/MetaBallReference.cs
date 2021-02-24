
using UnityEngine;

public static class MetaBallReference
{
    public enum MetaballShape { Circle, Square };

    public static readonly int EffectLayer = 8;
    public static readonly Color MaskColor = Color.green;

    public static class Shapes
    {
        public static Sprite Circle { get { return Resources.Load<Sprite>("Shapes/Circle"); } }
        public static Sprite Square { get { return Resources.Load<Sprite>("Shapes/Square"); } }

        public static Sprite GetSprite(MetaballShape shape)
        {
            switch (shape)
            {
                case MetaballShape.Circle:
                    return Circle;
                  
                case MetaballShape.Square:
                    return Square;
                    
                default:
                    return Circle;
                 
            }
        }

    }

}
