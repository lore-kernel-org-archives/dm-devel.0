From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: dmioscope: visualise IO distribution for DM devices
Date: Tue, 27 Sep 2016 14:56:45 +0100
Message-ID: <20160927135644.GA29650@localhost.localdomain>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: dm-devel@redhat.com
Cc: linux-lvm@redhat.com
List-Id: dm-devel.ids

I wanted to give a quick plug for a little tool I've been working on for
the last few weeks: dmioscope is a python script that uses device-mapper
statistics to generate histograms of IO distribution on a DM device:

# python dmioscope.py -C READS -b 6 3 0 vg_hex/root
Initialised READS adaptive histogram with 6 bins,
min_size=1677721.
vg_hex/root: current IO distribution
        0.0            2000.0         4000.0         6000.0         8000.0         
         +-------------------------------------------------------------
0.0B     |#######
5.3GiB   |#####################################################
10.7GiB  |#####
16.0GiB  |###
21.3GiB  |
26.7GiB  |
90.00% of IO reaches 50.00% of disk.
[...]

(watch reads, six bins, interval of 3s, carry on forever)

It's useful for finding and tracking hot-spots in real time, and for
getting a general picture of where IO is going to on a device. I'm
hoping it can also be used to get an idea of the benefits that can
be achieved with caching.

I've pushed it to GitHub - if anyone finds any bugs, or has any
suggestions, I'm very interested to hear them: there's a README.md with
usage information and more details on the histogram implementation on
the main page:

  https://github.com/bmr-cymru/dmioscope

Regards,
Bryn.

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
