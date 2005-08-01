From: "Thomas S. Iversen" <zensonic@zensonic.dk>
Subject: sectorsize and boundary in device mapper
Date: Mon, 1 Aug 2005 12:34:15 +0200
Message-ID: <200508011234.15846.zensonic@zensonic.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

Hi there

I have ported GBDE (Geom Based Block Device encryption) from freebsd to 
devicemapper under linux.

GBDE has a unique key pr. softsector. The size of a softsector can be either 
512, 1024, 2048 or 4096. dmbde currently supports a softsector size of 512. 
It doesn't support 1024, 2048 and  4096 as I do not know how to program my 
dm-plugin so that it requires BIOs on 1024, 2048 and 4096 boundries and with 
these sizes. Eg. emulate that my dmbde devices are block devices with at 
different hardsect size that 512.

Any clues? I investigated split_io with a chunksize, but couldn't figure out 
if it would work, or if split_io just sets a max size on the BIOs presented 
to the dm-plugins. If its only an upper limit it won't work, it has to be a 
firm limit; otherwise I have to satisfy requests where I have to fetch a 
whole softsector, decrypt it all, and only return a partial result. Not the 
right way to go IMHO.

Any help appriciated. 

Regards Thomas, Denmark
-- 
Bills travel through the mail at twice the speed of checks
