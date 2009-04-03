From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [PATCH 0/3] Some miscellaneous dm-multipath patches
Date: Sat, 4 Apr 2009 00:40:05 +0200
Message-ID: <20090404004005.1752889f@plop>
References: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1236883093-2989-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Le Thu, 12 Mar 2009 13:38:10 -0500,
Benjamin Marzinski <bmarzins@redhat.com> a =C3=A9crit :

> Here are a couple of my local multipath patches, that have been
> waiting to go upstream.
>=20
> -Ben

I applied the set:
- including your reworked stack size patch
- adding the add_handler() for {disable,restore}queueing in cli.h

Thanks.
