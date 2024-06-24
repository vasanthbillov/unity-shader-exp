using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SnackShaderController : MonoBehaviour
{
    public Material material;

    public int len;

    float[] array;

    int currentIdx = 0;

    bool ticks = true;    

    enum Direction { no, right, left, up, down } 

    Direction direction = Direction.no;

    int[] queue;  
    int head;       
    int count;      

    void Start()
    {
        material = GetComponent<MeshRenderer>().material;

        array = new float[len];

        queue = new int[6]; 

        head = 0;

        count = 0;
    }

    public void StoreIdxs(int newValue)
    {
        queue[head] = newValue;

        head = (head + 1) % queue.Length;

        if (count < queue.Length)
        {
            count++;
        }
    }

    void Update()
    {
       
        if (Input.GetKey(KeyCode.W) || Input.GetKey(KeyCode.UpArrow))
        {
            direction = Direction.up;
        }
        if (Input.GetKey(KeyCode.S) || Input.GetKey(KeyCode.DownArrow))
        {
            direction = Direction.down;
        }
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.LeftArrow))
        {
            direction = Direction.left;
        }
        if (Input.GetKey(KeyCode.D) || Input.GetKey(KeyCode.RightArrow))
        {
            direction = Direction.right;
        }

        StartCoroutine(UpdateSnackMovement());
    }

     IEnumerator UpdateSnackMovement()
    {
        if (ticks)
        {
            ticks = false;
            Paint();

            yield return new WaitForSeconds(0.5f); 
            
            ticks = true;

            if( direction == Direction.right){
                if (currentIdx < len-1){
                    currentIdx ++;
                }
            }

            if( direction == Direction.left){
                if (currentIdx < len-1){
                    currentIdx --;
                }
            }

            if( direction == Direction.up){
                if (currentIdx < len-1){
                    currentIdx += 10;
                }
            }

            if( direction == Direction.down){
                if (currentIdx > 0){
                    currentIdx -= 10;
                }
            }

             StoreIdxs(currentIdx);

        }
    }

    public float lerpduration = 0.2f;

    void Paint()
    {
        for (int i = 0; i < array.Length; i++)
        { array[i] = -5.0f;}

        for (int j = 0; j < queue.Length; j++)
        { array[queue[j]] = 200f;}

        material.SetFloatArray("_FloatArray", array);

    }

}
