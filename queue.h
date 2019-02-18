#define MAXSIZE 1000
struct queue
{
    char q [MAXSIZE][50];
     int front, rear;
};
typedef struct queue Queue;
Queue call_q = {.front = 0, .rear =0};
 
void enqueue(char* num);
void dequeue(void);
void qdisplay(void);


/*  Function to add an element to the stack */
void enqueue (char* num )
{
    //printf("\ncontant %s \n",num);
    if (call_q.rear == (MAXSIZE - 1))
    {
        printf ("queue is Full\n");
        return;
    }
    else
    {
	int i =0;
	while(num[i]!='\0')                                                   
   	 {
        	call_q.q[call_q.rear][i] = num[i];                                                    
        	i++;
    	 }
	call_q.q[call_q.rear][i] = num[i]; 
	call_q.rear = call_q.rear + 1; 
	//printf("\ncontant2  %s\n",call_q.q[call_q.rear -1 ]);
    }
    return;
}
/*  Function to delete an element from the stack */
void dequeue ()
{
    char* num;
    if (call_q.rear == 0)
    {
        printf ("q is Empty\n");
        
    }
    else
    {
        //num = place.stk[place.top];
        //printf ("poped element is = %sn", place.stk[place.top]);
        call_q.front = call_q.front + 1;
    }
    //return(num);
}
/*  Function to display the status of the stack */
void qdisplay ()
{
    int i;
    if (call_q.rear == 0)
    {
        printf ("Stack is empty\n");
        return;
    }
    else
    {
        printf ("\n The status of the q is %d \n",call_q.rear);
        for (i = call_q.front; i < call_q.rear; i++)
        {
	    int j = 0;
            //printf ("%s\n", place.stk[i]);
	    for (j = 0; call_q.q[i][j] != '\0'; j++)
		{
			printf ("%c\n", call_q.q[i][j]);
		}
        
        }
    }
    printf ("\n");
}
