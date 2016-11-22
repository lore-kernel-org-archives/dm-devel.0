From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] New device mapper target ZDM
Date: Tue, 22 Nov 2016 15:46:23 +0000
Message-ID: <20161122154623.GB22270@agk-dp.fab.redhat.com>
References: <20161121192311.14539-1-shaun@tancheff.com>
	<BLUPR02MB1683056A1D78B1A481A38CC181B40@BLUPR02MB1683.namprd02.prod.outlook.com>
	<CAJ48U8VwTCofzOC6n_RaG93WfxAxW2USy3dZ6w4Us_tx_Z3r1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAJ48U8VwTCofzOC6n_RaG93WfxAxW2USy3dZ6w4Us_tx_Z3r1A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Shaun Tancheff <shaun@tancheff.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Vineet Agarwal <vineet.agarwal@seagate.com>, dm-devel <dm-devel@redhat.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Michael T Lombardi <michael.t.lombardi@seagate.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Nov 22, 2016 at 09:35:28AM -0600, Shaun Tancheff wrote:
> I can move all but the 'status' to debugfs and move 'status' to sysfs
> and reformat
> the output as appropriate.... would that suffice?
 
First concentrate on working out how to shoe-horn the code into the standard
device-mapper interface model, like the existing dm targets.

The right location for the assorted things you've placed in /proc will then
drop out of that analysis.

Alasdair
