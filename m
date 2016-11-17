From: Barry Kauler <bkauler@gmail.com>
Subject: Re: [PATCH v5 0/3] init: add support to directly boot to
 a mapped device
Date: Thu, 17 Nov 2016 14:55:41 +0800
Message-ID: <CABWT5yhN6C91gwiA6hJJR0FfAjFK6goYha0PsMV=rSEu1gVsBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Hi,
I have just joined this list. I am a newcomer to using device-mapper.
I currently maintain Quirky Linux, prior to that, Puppy Linux. Puppy
uses overlay filesystems, usually aufs, to achieve what could also be
done, partly, with device-mapper.

Puppy has a initramfs, however, Quirky is a traditional full install,
and without an initramfs. When I cam across Kees Cook's v5 patches to
setup device mapping at the kernel boot params, I could see
possibilities for Quirky.

However, it seems that the 'table' format when using 'dmsetup create',
and also in the kernel boot params, that devices can only be specified
by the normal name (sd*) or by major:minor numbers.

This is what my understanding is, reading the docs. However, if I am
booting from a removable drive, that is not satisfactory.

I have sent a separate email direct to Kees, with more details. But
basically, my question is, could the 'table' format be extended to
accept PARTUUIDs, either the GUID format as used in GPT drives (use
'gdisk' to get it), or <NT disk identifier>-<partition number> format
for MBR disks.

For example, gdisk provides this for one of my flash sticks, second partition:

Partition GUID code: 0FC63DAF-8483-4772-8E79-3D69D8477DE4

And that can be used as a boot param:

root=PARTUUID=0FC63DAF-8483-4772-8E79-3D69D8477DE4

The kernel understands this type of UUID, so is it feasible for the
'table' format in Kee's patch to also accept it?

Please remember that I am a beginner to dm, so if you feel like
responding, please keep the explanations simple!

Regards,
Barry Kauler
