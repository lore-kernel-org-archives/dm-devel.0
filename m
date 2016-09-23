From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: current status of lvm cache
Date: Sat, 24 Sep 2016 00:50:43 +0300
Message-ID: <CACaajQs2YyrKdZXYQ8JuWGmDna_TDUz+d4YwnEjxT3+ELGGOpg@mail.gmail.com>
Reply-To: LVM general discussion and development <linux-lvm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-lvm-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-lvm>
List-Post: <mailto:linux-lvm@redhat.com>
List-Help: <mailto:linux-lvm-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-lvm>,
	<mailto:linux-lvm-request@redhat.com?subject=subscribe>
Sender: linux-lvm-bounces@redhat.com
Errors-To: linux-lvm-bounces@redhat.com
To: linux-lvm <linux-lvm@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi! Sometimes ago i'm use bcache for caching random write to ssd.
Also i read about lvm cache and some unsuccessful stories about it performance,
sometimes users don't have any benefits when try to use lvm cache.
So if i use kernel 4.7 - does lvm cache can give me performance boost
when random writing? Does it possible to bypass sequential i/o after
some threshold?
What kernel and lvm versions preferred to use to get maximum
performance in lvm cache?

Thanks!

-- 
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru

_______________________________________________
linux-lvm mailing list
linux-lvm@redhat.com
https://www.redhat.com/mailman/listinfo/linux-lvm
read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/
