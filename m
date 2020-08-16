From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Promise and ALUA
Date: Sun, 16 Aug 2020 05:50:09 +0200
Message-ID: <a00b22c2-64ba-4c2b-03a5-cc955d6c476c@gmail.com>
References: <20200810043316.GH21810@mayhem.atnf.CSIRO.AU>
	<8c910ecb-ddf8-0a91-4310-4daedb85cd89@gmail.com>
	<20200813235143.GB2644@mayhem.atnf.CSIRO.AU>
	<f9f8c62f-fa97-dbcb-52dd-503d392df95f@gmail.com>
	<20200814021835.GD2644@mayhem.atnf.CSIRO.AU>
	<30d53099-24dd-254a-13f2-9f1a488c1773@gmail.com>
	<20200816023037.GA13633@mayhem.atnf.CSIRO.AU>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200816023037.GA13633@mayhem.atnf.CSIRO.AU>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "McIntyre, Vincent (CASS, Marsfield)" <Vincent.Mcintyre@csiro.au>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 8/16/20 4:30 AM, McIntyre, Vincent (CASS, Marsfield) wrote:

> Promise recommend the multibus option,

Promise docs are a bit messy. The multibus example is a mistake.

There are only two options for this array: failover or group_by_prio.
There are plenty of examples, for old distributions, at
"Linux PerfectPath - Promise Multipath Driver", under:
https://www.promise.com/Support/DownloadCenter/VTrak/Ex30/E830f#Utilities

> Thanks for your analysis. The model is VTrak E830f (VTE830fD).
> The unit is definitely set to active-active controllers.

Yep, it's a dual controller array. But the controllers are no able to
access to a LUN at the same time, and from all paths.

Only high-end arrays(3PAR, Symmetrix, DS8000, ONTAP, VSP, ...) do this.

In VTrak arrays, one LUN is owned only by one controller.

> The firmware could use an update however, the latest release
> seems to have been overlooked. I'll try updating and look
> into enabling ALUA support.

If ALUA is not used, multipathd must be configured with the
"failover" option for "path_grouping_policy"

> One question about the man page though.
> it seems from the current text that putting
>    hardware_handler     "0"
> in the config would be ignored for arrays that are
> assumed to have ALUA support.
> However if the array has ALUA support turned off and
> multipathd detects this, then the package falls back to using
>    hardware_handler     "0"
> of its own accord?
> If that's correct, could that be added to the man page?

Debian 10 is using a very old multipath-tools release (0.7.9 - nov 2018)
without any upstream fixes. I don't know if it's an old bug or
the default setting "hardware_handler = 1 alua" was interfering.
