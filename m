From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: Promise and ALUA
Date: Thu, 13 Aug 2020 22:07:49 +0200
Message-ID: <8c910ecb-ddf8-0a91-4310-4daedb85cd89@gmail.com>
References: <20200810043316.GH21810@mayhem.atnf.CSIRO.AU>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200810043316.GH21810@mayhem.atnf.CSIRO.AU>
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
To: "McIntyre, Vincent (CASS, Marsfield)" <Vincent.Mcintyre@csiro.au>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 8/10/20 6:33 AM, McIntyre, Vincent (CASS, Marsfield) wrote:

> for many years we have been operating some Promise VTrak arrays
> without any use of the ALUA feature (largely so we don't have to
> specify LUN affinities as well, which seems to be required).
> 
> In the process of upgrading to Debian Buster
> (multipath-tools 0.7.9 and kernel 4.19)
> I find that I can no longer connect to our Promise arrays.
> They are detected but the only useful output I get is
> 
>   multipathd[986]: reconfigure (operator)
>   multipathd[986]: sdc: alua not supported
>   multipathd[986]: sdd: alua not supported
>   multipathd[986]: sdr: alua not supported
>   multipathd[986]: sde: alua not supported
>   multipathd[986]: sdf: alua not supported
>   multipathd[986]: sdg: alua not supported
>   multipathd[986]: sdh: alua not supported
>   multipathd[986]: sdi: alua not supported
> 
> 
> I found the note in the manpage about alua being selected by
> default for these arrays[1], but I'm taken aback that I'm not
> allowed to override this.
> 
> Is there really no support any more for choosing whether to use
> ALUA or not?
> 
> I have tried messing about with detect_prio, dectect_checker
> and whatnot, to no avail.

> [1] 9b5ea2eda85ae072cb697310807611c693713c2b
>      libmultipath: retain_attached_hw_handler obsolete with 4.3+

With the next array config and an empty /etc/multipath.conf,
reboot the linux host and put the output of "multipath -ll"
Redundancy Type: Active-Active
LUN Affinity: Enable
ALUA: Enable
