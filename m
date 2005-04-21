From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Making failover work quickly with QLogic HBAs
Date: Thu, 21 Apr 2005 15:48:53 +0200
Message-ID: <20050421134853.GM17315@marowsky-bree.de>
References: <20050421122328.GJ17315@marowsky-bree.de>
	<b4415a5867f3b25c8166bea8febd4b79@nanisky.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <b4415a5867f3b25c8166bea8febd4b79@nanisky.com>
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

On 2005-04-21T14:21:25, Arthur Bergman <sky@nanisky.com> wrote:

> There has been discussions that this is not supported behaviour and=20
> could cause problems, in particular the supported configurations of big=
=20
> blue for their SDD multipath product states that you shouldn't do=20
> this...

This is about DM multipath, not about SDD multipath, so I couldn't care
less about what big blue supports there ;-)

But seriously, can you point me at those discussions? Are there any real
problems caused by this beyond the depreciated sdd multipath...? It
seems to help quite a bit for me; w/o, failover times are inacceptable.


Mit freundlichen Gr=FC=DFen,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business
