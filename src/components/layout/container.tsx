import { ReactNode, FC } from 'react';

interface ContainerProps {
  children: ReactNode;
}

const Container: FC<ContainerProps> = ({ className, children }) => (
  <div className={`container mx-auto ${className}`}>{children}</div>
);

export default Container;
