#define MAXSIZE 1000

char quad_ruples[MAXSIZE][4][200];
// opration arg1 arg2 result
int nextquad = 0;
int* makelist(int i);
int* makelist2();
int* merge(int* p1,int* p2);
void backpatch(int* p, int i);
void emit(char* op, char* arg1, char* arg2, char* result);
void quad_display();


void quad_display(){
int i;
for(i=0; i<=nextquad-1; i++){
	printf("%d : quadruples: %s, %s, %s, %s\n",i,quad_ruples[i][0],quad_ruples[i][1],quad_ruples[i][2],quad_ruples[i][3]);
}
}
void emit(char* op, char* arg1, char* arg2, char* res){
  int i =0;
  while(op[i]!='\0'){
   quad_ruples[nextquad][0][i] = op[i];
  i++;
  }  
  quad_ruples[nextquad][0][i] = op[i];
  i =0;
  while(arg1[i]!='\0'){
   quad_ruples[nextquad][1][i] = arg1[i];
  i++;
  }  
  quad_ruples[nextquad][1][i] = arg1[i];
  i =0;
  while(arg2[i]!='\0'){
   quad_ruples[nextquad][2][i] = arg2[i];
  i++;
  }  
  quad_ruples[nextquad][2][i] = arg2[i];
  i =0;
  while(res[i]!='\0'){
   quad_ruples[nextquad][3][i] = res[i];
  i++;
  }  
  quad_ruples[nextquad][3][i] = res[i];

nextquad++;
//printf("\nquad:\n");
//quad_display();
//printf("\nquademit : %s, %s, %s, %s\n",quad_ruples[nextquad-1][0],quad_ruples[nextquad-1][1],quad_ruples[nextquad-1][2],quad_ruples[nextquad-1][3]);
}

int* makelist(int i){
int* list = (int*)malloc(sizeof(int)*2) ;
list[0] = 1;
list[1] = i;
//printf("\n size list: %d",(int)(sizeof(list)/sizeof(list[0])));
return list;
}
int* makelist2(){
int* list = (int*)malloc(sizeof(int)*2) ;
list[0] = 0;
//printf("\n size list: %d",(int)(sizeof(list)/sizeof(list[0])));
return list;
}

int* merge(int* p1,int* p2){
int n1 = *(p1);
int n2 = *(p2);
//printf("n1:%d n2:%d\n",*(p1+1),*(p2+1));
int* list = (int*)malloc(sizeof(int)*(n1+n2)) ;
list[0] = n1+n2;
int i;
for (i=1; i<=n1; i++){
	list[i] = p1[i];

}
for (i=1; i<=n2; i++){
	list[n1+i] = p2[i];
}

return list;
}

void backpatch(int* p, int i){
int n =p[0];
int j;
//printf("\nn:%d\n",n);
char num[5];
snprintf(num,5,"%d",i);
//printf("num:%s\n",num);
for (j=1; j<=n; j++){
  int i =0;
  while(num[i]!='\0'){
   quad_ruples[*(p+j)][3][i] = num[i];
  i++;
  }  
  quad_ruples[*(p+j)][3][i] = num[i];

	
}

}





