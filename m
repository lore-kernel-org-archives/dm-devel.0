From: "McIntyre, Vincent (CASS, Marsfield)" <Vincent.Mcintyre@csiro.au>
Subject: Re: Promise and ALUA
Date: Sun, 16 Aug 2020 02:30:43 +0000
Message-ID: <20200816023037.GA13633@mayhem.atnf.CSIRO.AU>
References: <20200810043316.GH21810@mayhem.atnf.CSIRO.AU>
	<8c910ecb-ddf8-0a91-4310-4daedb85cd89@gmail.com>
	<20200813235143.GB2644@mayhem.atnf.CSIRO.AU>
	<f9f8c62f-fa97-dbcb-52dd-503d392df95f@gmail.com>
	<20200814021835.GD2644@mayhem.atnf.CSIRO.AU>
	<30d53099-24dd-254a-13f2-9f1a488c1773@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <30d53099-24dd-254a-13f2-9f1a488c1773@gmail.com>
Content-Language: en-US
Content-ID: <6D588B6AD3CABD418084F22E2995AF86@ausprd01.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Aug 15, 2020 at 10:36:52PM +0200, Xose Vazquez Perez wrote:
>On 8/14/20 4:18 AM, McIntyre, Vincent (CASS, Marsfield) wrote:
>
>>This is the device section I had before for the Promise
>>         device {
>>                 vendor "Promise"
>>                 product "VTrak"
>>                 product_blacklist "VTrak V-LUN"
>                   path_grouping_policy "multibus" <---------
>>                 path_selector "service-time 0"
>>                 path_checker "tur"
>                   prio "alua"                     <---------
>>                 failback "immediate"
>>                 no_path_retry 30
>>         }
>>The only real differences are the prio and failback.
>
>"multibus" and "prio alua" are incompatible!

Promise recommend the multibus option,
prio alua was introduced by me messing about.

So a compatible configuration would be either what Promise recommend

  detect_prio          no       #not explicit, implied by prio const
  prio                 const
  path_grouping_policy multibus
  failback             immediate
  hardware_handler     "0"

or (with alua support enabled, the multipath-tools defaults)

  detect_prio          yes
  prio                 alua
  path_grouping_policy group_by_prio
  failback             manual
  hardware_handler     "1 alua"

?

From your tests and Promise docs, it looks like it's an Active-Passive array
>with ALUA support.
>It should use latest firmware [1]. And ALUA must be enabled to get the best
>performance and stability.
>Otherwise, the array will work with only one path per LUN.
>[1] https://www.promise.com/Support/DownloadCenter/VTrak/Ex30/E830f#Firmware
>
>The multipath-tools default settings is already optimized for the ALUA config.

Thanks for your analysis. The model is VTrak E830f (VTE830fD).
The unit is definitely set to active-active controllers.
The firmware could use an update however, the latest release
seems to have been overlooked. I'll try updating and look
into enabling ALUA support.

One question about the man page though.
it seems from the current text that putting
  hardware_handler     "0"
in the config would be ignored for arrays that are
assumed to have ALUA support.
However if the array has ALUA support turned off and
multipathd detects this, then the package falls back to using
  hardware_handler     "0"
of its own accord?
If that's correct, could that be added to the man page?

Cheers
Vince
