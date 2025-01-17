import React, { useEffect, useState } from 'react';
import { Grid } from '@material-ui/core';
import { InfoCard } from '@backstage/core-components';
import { useApi, identityApiRef, ProfileInfo } from '@backstage/core-plugin-api';
import { AnnouncementsTimeline } from '@backstage-community/plugin-announcements';

import {
  Content,
  Header,
  Page,
} from '@backstage/core-components';

const HomePage = () => {

  const identityApi = useApi(identityApiRef);
  const [profile, setProfile] = useState<ProfileInfo | null>(null);

  useEffect(() => {
    const fetchProfile = async () => {
      const userProfile = await identityApi.getProfileInfo();
      setProfile(userProfile);
    };

    fetchProfile();
  }, [identityApi]);

  if (!profile) {
    return <div>Carregando...</div>; // Exibe algo enquanto carrega
  }

  return (
    <Page themeId="home">
      <Header 
        title={`Seja bem-vindo${profile ? `, ${profile.displayName} 👋` : ''}`} 
      />
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
