From: Suleyman Kutlu <suleyman.kutlu@gmail.com>
Subject: Device Mapper corruption
Date: Mon, 11 Jul 2005 15:32:24 +0300
Message-ID: <42D266D8.6040001@gmail.com>
References: <00a501c57c92$c3041020$1f000064@polaris>
Reply-To: suleyman.kutlu@gmail.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <00a501c57c92$c3041020$1f000064@polaris>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello all,

I have an AMD-64 machine running SuSE 9.2. I have one disk (for now,
will add another later on) and a VG on it. I have created some LVs.

Sometimes later, I realized that when I mount an LV (lets call it
lv_a) I see the directory structure of another LV (lets call it lv_b). If I issue a df -k, I see the size of lv_b for lv_a,
but in lvdisplay output, the size for lv_a is correct.

/mnt is mounted as lv_b
/mnt2 is mounted as lv_a but has contents as lv_b has.

I thought that, filesystem structure is corrupted and started to work
on some filesystem level utilities today, but today I see that,
another filesystem pair also got the same problem.

So I think it is a problem in device-mapper level, not the filesystem level. 

What can be the possible works to get what is wrong and how to fix ? 

I am new at device-mapper, I don't have enough experience on it and I
do not want to loose everything while there is something that can be
recovered...

Any help is appreciated. 

Thanks and best regards.. 

* 
* Suleyman Kutlu
*
* mailto: suleyman.kutlu@gmail.com
*
