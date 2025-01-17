import React from 'react';
import { Grid } from '@material-ui/core';
import { InfoCard } from '@backstage/core-components';

import { AnnouncementsTimeline } from '@backstage-community/plugin-announcements';

import {
  Content,
  Header,
  Page,
} from '@backstage/core-components';

const HomePage = () => {

  return (
    <Page themeId="home">
      <Header title="Home" />
      <Content>
        <h1>Announcements Timeline</h1>
        <Grid container>
        <Grid item md={6}>
          <InfoCard>
            <AnnouncementsTimeline />
          </InfoCard>
        </Grid>
      </Grid>
      </Content>
    </Page>
  );
};

export const homePage = <HomePage />;
