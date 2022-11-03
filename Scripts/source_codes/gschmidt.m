function [Q,R]=gschmidt(z)
% Input: z (kxS matrix)
% Output: an m-by-n upper triangular matrix R
% and an m-by-m unitary matrix Q so that A = Q*R.
[k,S]=size(z);
R=zeros(S);
R(1,1)=norm(z(:,1));
Q(:,1)=z(:,1)/R(1,1);
for k=2:S
R(1:k-1,k)=Q(:,1:k-1)'*z(:,k);
Q(:,k)=z(:,k)-Q(:,1:k-1)*R(1:k-1,k);
R(k,k)=norm(Q(:,k));
Q(:,k)=Q(:,k)/R(k,k);
end
