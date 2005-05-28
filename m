From: Suleyman Nazif Kutlu <suleyman.kutlu@gmail.com>
Subject: corruption in LVM lv to dm mapping
Date: Sun, 29 May 2005 00:18:29 +0300
Message-ID: <70c557b20505281418438fbcab@mail.gmail.com>
Reply-To: Suleyman Nazif Kutlu <suleyman.kutlu@gmail.com>,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
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

Hi all,

I have an AMD-64 machine running SuSE 9.2. I have one disk (for now,
will add another later on) and a VG on it. I have created some LVs.

Sometimes later, I realized that when I mount an LV (lets call it
lv_a) I see the directory structure of another LV (lets call it lv_b)
but I can see that the LV has correct size in lvdisplay.

/mnt is mounted as lv_b
/mnt2 is mounted as lv_a but has contents as lv_b has.

I thought that, filesystem structure is corrupted and started to work
on some filesystem level utilities today, but today I see that,
another filesystem pair also got the same problem.

So I think it is a problem in device-mapper level, not the filesystem lev=
el.=20

What can be the possible works to get what is wrong and how to fix ?=20

I am new at device-mapper, I don't have enough experience on it and I
do not want to loose everything while there is something that can be
recovered...

Any help is appreciated.=20

Thanks and best regards..=20

*=20
* Suleyman Kutlu
*
* mailto: suleyman.kutlu@gmail.com
*
