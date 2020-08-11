From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH RFC] multipath-tools: *untested* use sysfs
 prio also for arrays with dual implicit/explicit alua support
Date: Tue, 11 Aug 2020 11:52:02 +0200
Message-ID: <7769b7b90b26f03536a7718501ff110cfbe1858c.camel@suse.com>
References: <acc2f009-c4b8-0c09-c77c-9400aac38cb1@gmail.com>
	<db83c4595e4e494d95c80825b1a66dfb77e14690.camel@suse.com>
	<DM6PR06MB5276C43B9BA875DA4B27497F8C440@DM6PR06MB5276.namprd06.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <DM6PR06MB5276C43B9BA875DA4B27497F8C440@DM6PR06MB5276.namprd06.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Schremmer, Steven" <Steve.Schremmer@netapp.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, Benjamin Marzinski <bmarzins@redhat.com>, Hannes Reinecke <hare@suse.de>, DM-DEVEL ML <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, 2020-08-10 at 21:27 +0000, Schremmer, Steven wrote:
> An RDAC array configured to run with Linux DM-MP should never report
> that it supports implicit and explicit ALUA support. If the array is
> configured to run with scsi_dh_rdac then it reports TPGS=0 (none) and
> should use rdac prio. The more modern configuration is to report
> TPGS=01b (implicit) and use scsi_dh_alua and alua prio.
> 
> Thanks,
> Steve

Thanks, Steve. AFAICS that means that we don't need the RFC patch.

Regards
Martin
