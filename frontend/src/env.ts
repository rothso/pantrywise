import { defineEnvVars } from '@sveltejs/kit/env';
import * as v from 'valibot';

export const variables = defineEnvVars({
  API_URL: {
    description: 'The base URL for the backend Golang API',
    schema: v.string(),
  },
});
