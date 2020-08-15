From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Promise and ALUA
Date: Sat, 15 Aug 2020 22:36:52 +0200
Message-ID: <30d53099-24dd-254a-13f2-9f1a488c1773@gmail.com>
References: <20200810043316.GH21810@mayhem.atnf.CSIRO.AU>
	<8c910ecb-ddf8-0a91-4310-4daedb85cd89@gmail.com>
	<20200813235143.GB2644@mayhem.atnf.CSIRO.AU>
	<f9f8c62f-fa97-dbcb-52dd-503d392df95f@gmail.com>
	<20200814021835.GD2644@mayhem.atnf.CSIRO.AU>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200814021835.GD2644@mayhem.atnf.CSIRO.AU>
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

On 8/14/20 4:18 AM, McIntyre, Vincent (CASS, Marsfield) wrote:

> This is the device section I had before for the Promise
>          device {
>                  vendor "Promise"
>                  product "VTrak"
>                  product_blacklist "VTrak V-LUN"
                    path_grouping_policy "multibus" <---------
>                  path_selector "service-time 0"
>                  path_checker "tur"
                    prio "alua"                     <---------
>                  failback "immediate"
>                  no_path_retry 30

"multibus" and "prio alua" are incompatible!

>          }
> The only real differences are the prio and failback.
 From your tests and Promise docs, it looks like it's an Active-Passive array
with ALUA support.
It should use latest firmware [1]. And ALUA must be enabled to get the best
performance and stability.
Otherwise, the array will work with only one path per LUN.

The multipath-tools default settings is already optimized for the ALUA config.


[1] https://www.promise.com/Support/DownloadCenter/VTrak/Ex30/E830f#Firmware
