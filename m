From: "McIntyre, Vincent (CASS, Marsfield)" <Vincent.Mcintyre@csiro.au>
Subject: Promise and ALUA
Date: Mon, 10 Aug 2020 04:33:19 +0000
Message-ID: <20200810043316.GH21810@mayhem.atnf.CSIRO.AU>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
Content-ID: <F8C563E331AF08459814C34E740E7633@ausprd01.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

for many years we have been operating some Promise VTrak arrays
without any use of the ALUA feature (largely so we don't have to
specify LUN affinities as well, which seems to be required).

In the process of upgrading to Debian Buster
(multipath-tools 0.7.9 and kernel 4.19)
I find that I can no longer connect to our Promise arrays.
They are detected but the only useful output I get is

 multipathd[986]: reconfigure (operator)
 multipathd[986]: sdc: alua not supported
 multipathd[986]: sdd: alua not supported
 multipathd[986]: sdr: alua not supported
 multipathd[986]: sde: alua not supported
 multipathd[986]: sdf: alua not supported
 multipathd[986]: sdg: alua not supported
 multipathd[986]: sdh: alua not supported
 multipathd[986]: sdi: alua not supported


I found the note in the manpage about alua being selected by
default for these arrays[1], but I'm taken aback that I'm not
allowed to override this.

Is there really no support any more for choosing whether to use
ALUA or not?

I have tried messing about with detect_prio, dectect_checker
and whatnot, to no avail.

Kind regards
Vince

[1] 9b5ea2eda85ae072cb697310807611c693713c2b
    libmultipath: retain_attached_hw_handler obsolete with 4.3+
