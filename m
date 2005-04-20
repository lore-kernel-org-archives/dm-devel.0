From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: release 0.4.4 ?
Date: Wed, 20 Apr 2005 16:04:08 +0200
Message-ID: <20050420140408.GX29071@marowsky-bree.de>
References: <1113731446.24817.4.camel@zezette>
	<1113953571.24817.97.camel@zezette>
	<20050420133116.GW29071@marowsky-bree.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050420133116.GW29071@marowsky-bree.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2005-04-20T15:31:17, Lars Marowsky-Bree <lmb@suse.de> wrote:

> > A lot of fixes flowed in since that proposal.
> > Now I propose pre16 as a 0.4.4 candidate.
> >=20
> > Objections still welcome.
> -pre16 /sbin/multipath doesn't create _any_ mapping for me.

The change to hwtable.c / config.c no longer can deal with store_hwe()
not filling in _all_ details.

It does not differentiate between a parameter being NULL because memory
couldn't be allocated and a parameter NULL (use default) being passed
in.

Replacing the NULL entries with "/bin/false" is a temporary
workaround...

Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
