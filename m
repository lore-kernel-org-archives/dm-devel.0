From: Walter de Jong <walter@sara.nl>
Subject: dm snapshot does implicit resume?
Date: Fri, 01 Apr 2005 15:47:42 +0200
Message-ID: <424D50FE.8090903@sara.nl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hi,

I'm not sure whether this is a dm or an lvm problem (or maybe it's a 
feature...) but it looks like snapshot does an implicit resume.
I have the feeling that this should be considered a bug.

observe:

dmsetup suspend /dev/mapper/some_vg-some_lv
lvcreate -s -L 10g -n snap /dev/some_vg/some_lv

The volume resumes automatigally without a need to run
dmsetup resume /dev/mapper/some_vg-some_lv



Also note how dmsetup requires the argument to be in the form
of "/dev/mapper/..." (/dev/some_vg/some_lv doesn't work here)
and lvcreate needs the form "/dev/some_vg/some_lv" 
(/dev/mapper/some_vg-some_lv doesn't work there) even though
they both have the same major,minor (in fact, /dev/some_vg/some_lv
is a symbolic link -> /dev/mapper/some_vg-some_lv)

This is on vanilla linux 2.6.11.6 (and many other 2.6.x versions)
with lvm2 2.01.04 and dmsetup 1.01.00

Greets,

      --Walter
-- 
                   *** If you build it, they will come ***

Walter de Jong
walter@sara.nl        http://www.sara.nl/
HPC Systems Programmer at SARA Computing and Network Services

People should be able to e-mail me, spambots should not.
