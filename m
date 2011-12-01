From: Douglas McClendon <dmc.lists@filteredperception.org>
Subject: Re: DM_snapshot_cow filesystem (dmsetup create snapshot)
Date: Thu, 01 Dec 2011 14:26:14 -0600
Message-ID: <4ED7E2E6.1010100@filteredperception.org>
References: <20111029204947.GU23336@agk-dp.fab.redhat.com>
	<CAEcBt+Ux+GVmm7zBeFA7k5PHOQoSKLTKcifB95ne5dBtX400dQ@mail.gmail.com>
	<4ED2DF0F.1070108@filteredperception.org>
	<CAEcBt+UEJXSY7oK+j0gw9fkzjnWOUcBFhPdXCVFe3HZNh6zOTw@mail.gmail.com>
	<4ED59040.50406@filteredperception.org>
	<CAEcBt+XxVh8b=TJu-Z+3XBL=K6LUhs2QZyeZKGMGh_Lp+UBGbA@mail.gmail.com>
	<20111130220259.GA7595@agk-dp.fab.redhat.com>
	<4ED6BD81.4090609@filteredperception.org>
	<20111201141236.GB7595@agk-dp.fab.redhat.com>
	<4ED7E11D.1090904@filteredperception.org>
	<20111201202029.GC7595@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111201202029.GC7595@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/01/2011 02:20 PM, Alasdair G Kergon wrote:
> On Thu, Dec 01, 2011 at 02:18:37PM -0600, Douglas McClendon wrote:
>> The overlay device in this situation is a read-write tmpfile in tmpfs,
>> looped to be available as the dm-snapshot 'snapshot/overlay device'.
>
> Ah - well if your base device is already read-only, then there is no
> corruption and you should be able to edit the bit of the disk image
> that says 'this image is invalid' and recover it read-only or extend it.

Can I get a commandline that summarizes how to do that 'edit'?

-dmc
