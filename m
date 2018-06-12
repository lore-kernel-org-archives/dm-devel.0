From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [Query] Failed to create dm-crypt device when using AEAD type
Date: Tue, 12 Jun 2018 13:37:46 +0800
Message-ID: <33220afd-9a26-6133-ebf0-83b1268c34b7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: wangxiongfeng2@huawei.com, broonie@linaro.org, arnd@arndb.de, joakim.bech@linaro.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Hi Dm-crypt maintainers,

Recently, I was testing the dm-crypt, but I failed to create dm-crypt device when using AEAD type.
I would really appreciate it if you could give some help.
The error info is as follows:
localhost:~ # export SIZE_INT=997376
8 J 0"ost:~ # dmsetup create integ1 --table "0 $SIZE_INT integrity /dev/sdd2 0 2
localhost:~ #
dom \host:~ # dmsetup create crypt1 --table "0 $SIZE_INT crypt capi:gcm(aes)-ran
>  11ff33c6fb942655efb3e30cf4c0fd95f5ef483afca72166c530ae26151dd83b \
>  0 /dev/mapper/integ1 0 1 integrity:28:aead"
[ 1746.631559] device-mapper: crypt: Integrity AEAD, tag size 16, IV size 12.
[ 1746.649796] device-mapper: crypt: INTEGRITY AEAD ERROR, sector 997248
[ 1746.656382] device-mapper: crypt: INTEGRITY AEAD ERROR, sector 997248
[ 1746.662826] Buffer I/O error on dev dm-3, logical block 124656, async page read

I tested it both on qemu and hardware, and it printed the same error.
The error seems always on the last several sectors within the SIZE_INT I designated.
When I change the SIZE_INT, the error sector num also change.
I think something went wrong in the software, not the hardware.

My board don't have AEAD accelerator, so it uses the software implemented cipher.
My kernel version is 4.17-rc3.

The command is as follows:
export SIZE_INT=997376
dmsetup create integ1 --table "0 $SIZE_INT integrity /dev/sdd2 0 28 J 0"
dmsetup create crypt1 --table "0 $SIZE_INT crypt capi:gcm(aes)-random \
 11ff33c6fb942655efb3e30cf4c0fd95f5ef483afca72166c530ae26151dd83b \
 0 /dev/mapper/integ1 0 1 integrity:28:aead"

This command comes from the commit information of the commit which introduce AEAD.
(commit ef43aa38063a6b2b3c6618e28ab35794f4f1fe29
dm crypt: add cryptographic data integrity protection (authenticated encryption))
I only change 'aes-gcm-random' to 'capi:gcm(aes)-random'

Really appreciate it if you could have a look at it, Thanks!

Regards,
Xiongfeng
