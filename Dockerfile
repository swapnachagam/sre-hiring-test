FROM public.ecr.aws/lambda/nodejs:14
COPY . ${LAMBDA_TASK_ROOT}
RUN npm ci
CMD [ "app.lambdaHandler" ]
