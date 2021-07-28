Return-Path: <SRS0=mcEr=MU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90640C432BE
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:25:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 88EB760FC2
	for <dm-devel@archiver.kernel.org>; Wed, 28 Jul 2021 11:24:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 88EB760FC2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-OrhEbAAPMICmxzpfXltYcg-1; Wed, 28 Jul 2021 07:24:54 -0400
X-MC-Unique: OrhEbAAPMICmxzpfXltYcg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CF53192FDAE;
	Wed, 28 Jul 2021 11:24:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B0B960CC6;
	Wed, 28 Jul 2021 11:24:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 60383180BAB0;
	Wed, 28 Jul 2021 11:24:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16SBOdEX003654 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Jul 2021 07:24:39 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 365D12069017; Wed, 28 Jul 2021 11:24:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 30F272014FA2
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 11:24:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 617361857F03
	for <dm-devel@redhat.com>; Wed, 28 Jul 2021 11:24:36 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-557-7nP5IdM4PkC6_JpgkndS8w-1;
	Wed, 28 Jul 2021 07:24:33 -0400
X-MC-Unique: 7nP5IdM4PkC6_JpgkndS8w-1
Received: by verein.lst.de (Postfix, from userid 2407)
	id 29FC667373; Wed, 28 Jul 2021 13:24:31 +0200 (CEST)
Date: Wed, 28 Jul 2021 13:24:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: Milan Broz <gmazyland@gmail.com>
Message-ID: <20210728112430.GA22101@lst.de>
References: <20210725055458.29008-1-hch@lst.de> <YQAtNkd8T1w/cSLc@redhat.com>
	<20210727160226.GA17989@lst.de> <YQAxyjrGJpl7UkNG@redhat.com>
	<9c719e1d-f8da-f1f3-57a9-3802aa1312d4@gmail.com>
	<20210728070655.GA5086@lst.de>
	<9e668239-78cc-55ad-8998-b7e39f573c34@gmail.com>
MIME-Version: 1.0
In-Reply-To: <9e668239-78cc-55ad-8998-b7e39f573c34@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@redhat.com>
Subject: Re: [dm-devel] use regular gendisk registration in device mapper
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Jul 28, 2021 at 10:37:41AM +0200, Milan Broz wrote:
> very specific hw attributes. So you have one emulated device compiled-in?

Yes.

> Or there is another way how to configure scsi_debug if compiled-in? (we use module parameters, I think it is
> the same was how util-linux testsute works with scsi_debug).

Can can add hosts using the add_host sysfs file.  I thought that was the
way to go generally, never thought of reloading the module just to
add/delete hosts.

> (BTW could you send me output of the failed test run? I run it over Linus' tree and ti works so it is perhaps another
> assumption that should be fixed.)

Output with everything from the README installed (a lot less failures now):


Making check in po
make[1]: Entering directory '/root/cryptsetup/po'
make[1]: Nothing to be done for 'check'.
make[1]: Leaving directory '/root/cryptsetup/po'
Making check in tests
make[1]: Entering directory '/root/cryptsetup/tests'
make  check-am
make[2]: Entering directory '/root/cryptsetup/tests'
make  api-test api-test-2 differ vectors-test unit-utils-io all-symbols-test
make[3]: Entering directory '/root/cryptsetup/tests'
make[3]: 'api-test' is up to date.
make[3]: 'api-test-2' is up to date.
make[3]: 'differ' is up to date.
make[3]: 'vectors-test' is up to date.
make[3]: 'unit-utils-io' is up to date.
make[3]: 'all-symbols-test' is up to date.
make[3]: Leaving directory '/root/cryptsetup/tests'
make  check-TESTS
make[3]: Entering directory '/root/cryptsetup/tests'
Cryptsetup test environment (Wed Jul 28 10:59:13 UTC 2021)
Linux testvm 5.14.0-rc2+ #53 SMP PREEMPT Wed Jul 28 12:57:30 CEST 2021 x86_64 GNU/Linux
Debian GNU/Linux 10 (buster) (Debian GNU/Linux) 10 (buster)
Memory
              total        used        free      shared  buff/cache   available
Mem:          3.8Gi       173Mi       3.5Gi       9.0Mi       157Mi       3.6Gi
Swap:            0B          0B          0B
../cryptsetup 2.4.0-rc0
../veritysetup 2.4.0-rc0
../integritysetup 2.4.0-rc0
../cryptsetup-reencrypt 2.4.0-rc0
Cryptsetup defaults:
Default compiled-in metadata format is LUKS2 (for luksFormat action).

LUKS2 external token plugin support is compiled-in.
LUKS2 external token plugin path: /usr/lib/cryptsetup.

Default compiled-in key and passphrase parameters:
	Maximum keyfile size: 8192kB, Maximum interactive passphrase length 512 (characters)
Default PBKDF for LUKS1: pbkdf2, iteration time: 2000 (ms)
Default PBKDF for LUKS2: argon2id
	Iteration time: 2000, Memory required: 1048576kB, Parallel threads: 4

Default compiled-in device cipher parameters:
	loop-AES: aes, Key 256 bits
	plain: aes-cbc-essiv:sha256, Key: 256 bits, Password hashing: ripemd160
	LUKS: aes-xts-plain64, Key: 256 bits, LUKS header hashing: sha256, RNG: /dev/urandom
	LUKS: Default keysize with XTS mode (two internal keys) will be doubled.
Library version:   1.02.155 (2018-12-18)
Driver version:    4.45.0
Device mapper targets:
thin-pool        v1.22.0
thin             v1.22.0
zero             v1.1.0
mirror           v1.14.0
snapshot-merge   v1.5.0
snapshot-origin  v1.9.0
snapshot         v1.16.0
multipath        v1.14.0
crypt            v1.23.0
striped          v1.6.0
linear           v1.4.0
error            v1.5.0
PASS: 00modules-test
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module dm-crypt not found in directory /lib/modules/5.14.0-rc2+
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module dm-verity not found in directory /lib/modules/5.14.0-rc2+
NonFIPSAlg: Crypto is properly initialised in format
AddDevicePlain: A plain device API creation
HashDevicePlain: A plain device API hash
AddDeviceLuks: Format and use LUKS device
LuksHeaderLoad: Header load
LuksHeaderRestore: LUKS header restore
LuksHeaderBackup: LUKS header backup
ResizeDeviceLuks: LUKS device resize
UseLuksDevice: Use pre-formated LUKS device
SuspendDevice: Suspend/Resume
UseTempVolumes: Format and use temporary encrypted device
CallbacksTest: API callbacks
VerityTest: DM verity
WARNING: kernel dm-verity not supported, skipping test.
TcryptTest: Tcrypt API
WARNING: algif_skcipher interface not present, skipping test.
IntegrityTest: Integrity API
WARNING: cannot format integrity device, skipping test.
PASS: api-test
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module dm-crypt not found in directory /lib/modules/5.14.0-rc2+
Cannot set test devices.
SKIP: api-test-2
[1] Current state
PASS: compat-test-args
CASE: Image in file tests (root capabilities not required)
[1] format
[2] open
[3] add key
[4] change key
[5] remove key
[6] kill slot
[7] header backup
[8] header restore
[9] luksDump
[10] uuid
CASE: [1] open - compat image - acceptance check
CASE: [2] open - compat image - denial check
CASE: [3] format
CASE: [4] format using hash sha512
CASE: [5] open
CASE: [6] add key
CASE: [7] unsuccessful delete
CASE: [8] successful delete
CASE: [9] add key test for key files
CASE: [10] delete key test with key1 as remaining key
CASE: [11] delete last key
CASE: [12] parameter variation test
CASE: [13] open/close - stacked devices
CASE: [14] format/open - passphrase on stdin & new line
CASE: [15] UUID - use and report provided UUID
CASE: [16] luksFormat
CASE: [17] AddKey volume key, passphrase and keyfile
CASE: [18] RemoveKey passphrase and keyfile
CASE: [19] create & status & resize
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc2+
This kernel seems to not support proper scsi_debug module, test skipped.
SKIP: compat-test
CASE: [0] Detect LUKS2 environment
CASE: [1] Data offset
CASE: [2] Sector size and old payload alignment
CASE: [3] format
CASE: [4] format using hash sha512
CASE: [5] open
CASE: [6] add key
CASE: [7] unsuccessful delete
CASE: [8] successful delete
CASE: [9] add key test for key files
CASE: [10] delete key test with key1 as remaining key
CASE: [11] delete last key
CASE: [12] parameter variation test
CASE: [13] open/close - stacked devices
CASE: [14] format/open - passphrase on stdin & new line
CASE: [15] UUID - use and report provided UUID
CASE: [16] luksFormat
CASE: [17] AddKey volume key, passphrase and keyfile
CASE: [18] RemoveKey passphrase and keyfile
CASE: [19] create & status & resize
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc2+
This kernel seems to not support proper scsi_debug module, test skipped.
SKIP: compat-test2
Open loop-AES key_v1 / AES-128 / offset 0 [keyfile:OK][stdin:OK]
Open loop-AES key_v1 / AES-128 / offset 8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v1 / AES-128 / offset @8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v1 / AES-128 / offset 8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v1 / AES-128 / offset @8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-128 / offset 0 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-128 / offset 8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-128 / offset @8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-128 / offset 8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-128 / offset @8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-128 / offset 0 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-128 / offset 8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-128 / offset @8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-128 / offset 8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-128 / offset @8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v1 / AES-256 / offset 0 [keyfile:OK][stdin:OK]
Open loop-AES key_v1 / AES-256 / offset 8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v1 / AES-256 / offset @8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v1 / AES-256 / offset 8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v1 / AES-256 / offset @8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-256 / offset 0 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-256 / offset 8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-256 / offset @8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-256 / offset 8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v2 / AES-256 / offset @8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-256 / offset 0 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-256 / offset 8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-256 / offset @8192 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-256 / offset 8388608 [keyfile:OK][stdin:OK]
Open loop-AES key_v3 / AES-256 / offset @8388608 [keyfile:OK][stdin:OK]
PASS: loopaes-test
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc2+
SKIP: align-test
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc2+
SKIP: align-test2
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc2+
SKIP: discards-test
aes                            PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-plain                      PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
null                           PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
cipher_null                    PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
cipher_null-ecb                PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-ecb                        PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
twofish-ecb                    PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-ecb                    PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
aes-cbc-null                   PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-cbc-benbi                  PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-cbc-plain                  PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-cbc-plain64                PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-cbc-essiv:sha256           PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-lrw-null                   PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
aes-lrw-benbi                  PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
aes-lrw-plain                  PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
aes-lrw-plain64                PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
aes-lrw-essiv:sha256           PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
aes-xts-null                   PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-xts-benbi                  PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-xts-plain                  PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-xts-plain64                PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
aes-xts-essiv:sha256           PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] LUKS2:[table OK][status OK] CHECKSUM:[OK]
twofish-cbc-null               PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-cbc-benbi              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-cbc-plain              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-cbc-plain64            PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-cbc-essiv:sha256       PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-lrw-null               PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-lrw-benbi              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-lrw-plain              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-lrw-plain64            PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-lrw-essiv:sha256       PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-xts-null               PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-xts-benbi              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-xts-plain              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-xts-plain64            PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
twofish-xts-essiv:sha256       PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-cbc-null               PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-cbc-benbi              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-cbc-plain              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-cbc-plain64            PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-cbc-essiv:sha256       PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-lrw-null               PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-lrw-benbi              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-lrw-plain              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-lrw-plain64            PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-lrw-essiv:sha256       PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-xts-null               PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-xts-benbi              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-xts-plain              PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-xts-plain64            PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
serpent-xts-essiv:sha256       PLAIN:[table OK][status OK] LUKS1:[table OK][status OK] CHECKSUM:[OK]
xchacha12,aes-adiantum-plain64 [n/a]
xchacha20,aes-adiantum-plain64 [n/a]
PASS: mode-test
HASH: ripemd160 KSIZE: 0 / pwd [OK]
HASH: ripemd160 KSIZE: 256 / pwd [OK]
HASH: ripemd160 KSIZE: 128 / pwd [OK]
HASH: sha1 KSIZE: 256 / pwd [OK]
HASH: sha1 KSIZE: 128 / pwd [OK]
HASH: sha256 KSIZE: 256 / pwd [OK]
HASH: sha256 KSIZE: 128 / pwd [OK]
HASH: sha256 KSIZE: 0 / std- [OK]
HASH: sha256 KSIZE: 256 / std- [OK]
HASH: sha256 KSIZE: 128 / std- [OK]
HASH: sha256 KSIZE: 256 / stdin [OK]
HASH: sha256 KSIZE: 0 / stdin [OK]
HASH: ripemd160 KSIZE: 256 / file [OK]
HASH: sha256 KSIZE: 256 / file [OK]
HASH: unknown* KSIZE: 256 / file [OK]
HASH: sha256:20 KSIZE: 256 / pwd [OK]
HASH: sha256:32 KSIZE: 256 / pwd [OK]
HASH: sha256: KSIZE: 256 / failpwd [OK]
HASH: sha256:xx KSIZE: 256 / failpwd [OK]
HASH: ripemd160 KSIZE: 256 / file [OK]
HASH: sha256 KSIZE: 256 / file [OK]
HASH: sha256 KSIZE: 128 / file [OK]
HASH: sha256 KSIZE: 512 / file [OK]
HASH: plain KSIZE: 128 / cat [OK]
HASH: plain KSIZE: 128 / cat [OK]
HASH: plain KSIZE: 128 / cat [OK]
HASH: plain KSIZE: 128 / cat- [OK]
HASH: plain KSIZE: 128 / cat- [OK]
HASH: sha256 KSIZE: 128 / cat- [OK]
HASH: sha256 KSIZE: 128 / cat- [OK]
HASH: sha256 KSIZE: 128 / cat- [OK]
HASH: sha256 KSIZE: 128 / cat- [OK]
HASH: sha256 KSIZE: 128 / cat- [OK]
HASH: sha256 KSIZE: 128 / cat- [OK]
HASH: plain KSIZE: 256 / pwd [OK]
HASH: plain:2 KSIZE: 256 / pwd [OK]
HASH: plain:9 KSIZE: 256 / failpwd [OK]
HASH: sha256 KSIZE: 128 / cat [OK]
HASH: sha256:14 KSIZE: 128 / cat [OK]
HASH: sha256 KSIZE: 128 / pwd [OK]
HASH: sha256 KSIZE: 128 / pwd [OK]
HASH: sha256 KSIZE: 128 / pwd [OK]
HASH: sha1 KSIZE: 256 / pwd [OK]
HASH: sha224 KSIZE: 256 / pwd [OK]
HASH: sha256 KSIZE: 256 / pwd [OK]
HASH: sha384 KSIZE: 256 / pwd [OK]
HASH: sha512 KSIZE: 256 / pwd [OK]
HASH: ripemd160 KSIZE: 256 / pwd [OK]
HASH: whirlpool KSIZE: 256 / pwd [OK]
HASH: sha3-224 KSIZE: 256 / pwd [OK]
HASH: sha3-256 KSIZE: 256 / pwd [OK]
HASH: sha3-384 KSIZE: 256 / pwd [OK]
HASH: sha3-512 KSIZE: 256 / pwd [OK]
HASH: sm3 KSIZE: 256 / pwd [OK]
HASH: stribog512 KSIZE: 256 / pwd [N/A] (1, SKIPPED)
PASS: password-hash-test
REQUIRED KDF TEST
pbkdf2-sha256 [OK]
pbkdf2-sha512 [OK]
pbkdf2-ripemd160 [OK]
pbkdf2-whirlpool [OK]
pbkdf2-stribog512 [N/A]
REQUIRED CIPHERS TEST
aes-cbc [N/A]
aes-lrw [N/A]
aes-xts [N/A]
twofish-ecb [N/A]
twofish-cbc [N/A]
twofish-lrw [N/A]
twofish-xts [N/A]
serpent-ecb [N/A]
serpent-cbc [N/A]
serpent-lrw [N/A]
serpent-xts [N/A]
blowfish-cbc [N/A]
des3_ede-cbc [N/A]
cast5-cbc [N/A]
camellia-xts [N/A]
kuznyechik-xts [N/A]
No remaining images.
Test skipped.
SKIP: tcrypt-compat-test
REQUIRED KDF TEST
REQUIRED CIPHERS TEST
#     Algorithm | Key |  Encryption |  Decryption
Cipher aes-xts (with 256 bits key) is not available.
Required kernel crypto interface not available.
Ensure you have algif_skcipher kernel module loaded.
Test skipped.
SKIP: luks1-compat-test
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module dm-crypt not found in directory /lib/modules/5.14.0-rc2+
FAIL dm-crypt failed to load
FAILED backtrace:
51 ./device-test
122 main ./device-test
FAIL: device-test
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module dm-crypt not found in directory /lib/modules/5.14.0-rc2+
dm-crypt failed to load
FAILED backtrace:
81 ./keyring-test
FAIL: keyring-test
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module dm-crypt not found in directory /lib/modules/5.14.0-rc2+
dm-crypt failed to load
FAILED backtrace:
117 ./keyring-compat-test
FAIL: keyring-compat-test
[0] Generating test headers
generate-luks2-area-in-json-hdr-space-json0.img.sh...done
generate-luks2-argon2-leftover-params.img.sh...done
generate-luks2-correct-full-json0.img.sh...done
generate-luks2-corrupted-hdr0-with-correct-chks.img.sh...done
generate-luks2-corrupted-hdr1-with-correct-chks.img.sh...done
generate-luks2-invalid-checksum-both-hdrs.img.sh...done
generate-luks2-invalid-checksum-hdr0.img.sh...done
generate-luks2-invalid-checksum-hdr1.img.sh...done
generate-luks2-invalid-json-size-c0.img.sh...done
generate-luks2-invalid-json-size-c1.img.sh...done
generate-luks2-invalid-json-size-c2.img.sh...done
generate-luks2-invalid-keyslots-size-c0.img.sh...done
generate-luks2-invalid-keyslots-size-c1.img.sh...done
generate-luks2-invalid-keyslots-size-c2.img.sh...done
generate-luks2-invalid-object-type-json0.img.sh...done
generate-luks2-invalid-opening-char-json0.img.sh...done
generate-luks2-keyslot-missing-digest.img.sh...done
generate-luks2-keyslot-too-many-digests.img.sh...done
generate-luks2-metadata-size-128k-secondary.img.sh...done
generate-luks2-metadata-size-128k.img.sh...done
generate-luks2-metadata-size-16k-secondary.img.sh...done
generate-luks2-metadata-size-1m-secondary.img.sh...done
generate-luks2-metadata-size-1m.img.sh...done
generate-luks2-metadata-size-256k-secondary.img.sh...done
generate-luks2-metadata-size-256k.img.sh...done
generate-luks2-metadata-size-2m-secondary.img.sh...done
generate-luks2-metadata-size-2m.img.sh...done
generate-luks2-metadata-size-32k-secondary.img.sh...done
generate-luks2-metadata-size-32k.img.sh...done
generate-luks2-metadata-size-4m-secondary.img.sh...done
generate-luks2-metadata-size-4m.img.sh...done
generate-luks2-metadata-size-512k-secondary.img.sh...done
generate-luks2-metadata-size-512k.img.sh...done
generate-luks2-metadata-size-64k-inv-area-c0.img.sh...done
generate-luks2-metadata-size-64k-inv-area-c1.img.sh...done
generate-luks2-metadata-size-64k-inv-keyslots-size-c0.img.sh...done
generate-luks2-metadata-size-64k-secondary.img.sh...done
generate-luks2-metadata-size-64k.img.sh...done
generate-luks2-missing-keyslot-referenced-in-digest.img.sh...done
generate-luks2-missing-keyslot-referenced-in-token.img.sh...done
generate-luks2-missing-segment-referenced-in-digest.img.sh...done
generate-luks2-missing-trailing-null-byte-json0.img.sh...done
generate-luks2-non-null-byte-beyond-json0.img.sh...done
generate-luks2-non-null-bytes-beyond-json0.img.sh...done
generate-luks2-overlapping-areas-c0-json0.img.sh...done
generate-luks2-overlapping-areas-c1-json0.img.sh...done
generate-luks2-overlapping-areas-c2-json0.img.sh...done
generate-luks2-pbkdf2-leftover-params-0.img.sh...done
generate-luks2-pbkdf2-leftover-params-1.img.sh...done
generate-luks2-segment-crypt-missing-encryption.img.sh...done
generate-luks2-segment-crypt-missing-ivoffset.img.sh...done
generate-luks2-segment-crypt-missing-sectorsize.img.sh...done
generate-luks2-segment-crypt-wrong-encryption.img.sh...done
generate-luks2-segment-crypt-wrong-ivoffset.img.sh...done
generate-luks2-segment-crypt-wrong-sectorsize-0.img.sh...done
generate-luks2-segment-crypt-wrong-sectorsize-1.img.sh...done
generate-luks2-segment-crypt-wrong-sectorsize-2.img.sh...done
generate-luks2-segment-missing-offset.img.sh...done
generate-luks2-segment-missing-size.img.sh...done
generate-luks2-segment-missing-type.img.sh...done
generate-luks2-segment-two.img.sh...done
generate-luks2-segment-unknown-type.img.sh...done
generate-luks2-segment-wrong-backup-key-0.img.sh...done
generate-luks2-segment-wrong-backup-key-1.img.sh...done
generate-luks2-segment-wrong-flags-element.img.sh...done
generate-luks2-segment-wrong-flags.img.sh...done
generate-luks2-segment-wrong-offset.img.sh...done
generate-luks2-segment-wrong-size-0.img.sh...done
generate-luks2-segment-wrong-size-1.img.sh...done
generate-luks2-segment-wrong-size-2.img.sh...done
generate-luks2-segment-wrong-type.img.sh...done
generate-luks2-uint64-max-segment-size.img.sh...done
generate-luks2-uint64-overflow-segment-size.img.sh...done
generate-luks2-uint64-signed-segment-size.img.sh...done
[1] Test basic auto-recovery
Test image: luks2-invalid-checksum-hdr0.img...OK
Test image: luks2-invalid-checksum-hdr1.img...OK
Test image: luks2-invalid-checksum-both-hdrs.img...OK
[2] Test ability to auto-correct mallformed json area
Test image: luks2-corrupted-hdr0-with-correct-chks.img...OK
Test image: luks2-corrupted-hdr1-with-correct-chks.img...OK
Test image: luks2-correct-full-json0.img...OK
Test image: luks2-argon2-leftover-params.img...OK
Test image: luks2-pbkdf2-leftover-params-0.img...OK
Test image: luks2-pbkdf2-leftover-params-1.img...OK
[3] Test LUKS2 json area restrictions
Test image: luks2-non-null-byte-beyond-json0.img...OK
Test image: luks2-non-null-bytes-beyond-json0.img...OK
Test image: luks2-missing-trailing-null-byte-json0.img...OK
Test image: luks2-invalid-opening-char-json0.img...OK
Test image: luks2-invalid-object-type-json0.img...OK
Test image: luks2-overlapping-areas-c0-json0.img...OK
Test image: luks2-overlapping-areas-c1-json0.img...OK
Test image: luks2-overlapping-areas-c2-json0.img...OK
Test image: luks2-area-in-json-hdr-space-json0.img...OK
Test image: luks2-missing-keyslot-referenced-in-digest.img...OK
Test image: luks2-missing-segment-referenced-in-digest.img...OK
Test image: luks2-missing-keyslot-referenced-in-token.img...OK
Test image: luks2-keyslot-missing-digest.img...OK
Test image: luks2-keyslot-too-many-digests.img...OK
[4] Test integers value limits
Test image: luks2-uint64-max-segment-size.img...OK
Test image: luks2-uint64-overflow-segment-size.img...OK
Test image: luks2-uint64-signed-segment-size.img...OK
[5] Test segments validation
Test image: luks2-segment-missing-type.img...OK
Test image: luks2-segment-wrong-type.img...OK
Test image: luks2-segment-missing-offset.img...OK
Test image: luks2-segment-wrong-offset.img...OK
Test image: luks2-segment-missing-size.img...OK
Test image: luks2-segment-wrong-size-0.img...OK
Test image: luks2-segment-wrong-size-1.img...OK
Test image: luks2-segment-wrong-size-2.img...OK
Test image: luks2-segment-crypt-missing-encryption.img...OK
Test image: luks2-segment-crypt-wrong-encryption.img...OK
Test image: luks2-segment-crypt-missing-ivoffset.img...OK
Test image: luks2-segment-crypt-wrong-ivoffset.img...OK
Test image: luks2-segment-crypt-missing-sectorsize.img...OK
Test image: luks2-segment-crypt-wrong-sectorsize-0.img...OK
Test image: luks2-segment-crypt-wrong-sectorsize-1.img...OK
Test image: luks2-segment-crypt-wrong-sectorsize-2.img...OK
Test image: luks2-segment-unknown-type.img...OK
Test image: luks2-segment-two.img...OK
Test image: luks2-segment-wrong-flags.img...OK
Test image: luks2-segment-wrong-flags-element.img...OK
Test image: luks2-segment-wrong-backup-key-0.img...OK
Test image: luks2-segment-wrong-backup-key-1.img...OK
[6] Test metadata size and keyslots size (config section)
Test image: luks2-invalid-keyslots-size-c0.img...OK
Test image: luks2-invalid-keyslots-size-c1.img...OK
Test image: luks2-invalid-keyslots-size-c2.img...OK
Test image: luks2-invalid-json-size-c0.img...OK
Test image: luks2-invalid-json-size-c1.img...OK
Test image: luks2-invalid-json-size-c2.img...OK
Test image: luks2-metadata-size-32k.img...OK
Test image: luks2-metadata-size-64k.img...OK
Test image: luks2-metadata-size-64k-inv-area-c0.img...OK
Test image: luks2-metadata-size-64k-inv-area-c1.img...OK
Test image: luks2-metadata-size-64k-inv-keyslots-size-c0.img...OK
Test image: luks2-metadata-size-128k.img...OK
Test image: luks2-metadata-size-256k.img...OK
Test image: luks2-metadata-size-512k.img...OK
Test image: luks2-metadata-size-1m.img...OK
Test image: luks2-metadata-size-2m.img...OK
Test image: luks2-metadata-size-4m.img...OK
Test image: luks2-metadata-size-16k-secondary.img...OK
Test image: luks2-metadata-size-32k-secondary.img...OK
Test image: luks2-metadata-size-64k-secondary.img...OK
Test image: luks2-metadata-size-128k-secondary.img...OK
Test image: luks2-metadata-size-256k-secondary.img...OK
Test image: luks2-metadata-size-512k-secondary.img...OK
Test image: luks2-metadata-size-1m-secondary.img...OK
Test image: luks2-metadata-size-2m-secondary.img...OK
Test image: luks2-metadata-size-4m-secondary.img...OK
PASS: luks2-validation-test
Cannot find dm-integrity target, test skipped.
SKIP: luks2-integrity-test
Test vectors using OpenSSL 1.1.1d  10 Sep 2019 crypto backend.
PBKDF vector 00 argon2i [OK]
PBKDF vector 01 argon2id [OK]
PBKDF vector 02 pbkdf2 [OK]
PBKDF vector 03 pbkdf2 [OK]
PBKDF vector 04 pbkdf2 [OK]
PBKDF vector 05 pbkdf2 [OK]
PBKDF vector 06 pbkdf2 [OK]
PBKDF vector 07 pbkdf2 [OK]
PBKDF vector 08 pbkdf2 [OK]
PBKDF vector 09 pbkdf2 [OK]
PBKDF vector 10 pbkdf2 [OK]
PBKDF vector 11 pbkdf2 [OK]
PBKDF vector 12 pbkdf2 [OK]
PBKDF vector 13 pbkdf2 [OK]
PBKDF vector 14 pbkdf2 [OK]
PBKDF vector 15 pbkdf2 [OK]
PBKDF vector 16 pbkdf2 [OK]
PBKDF vector 17 pbkdf2 [OK]
PBKDF vector 18 pbkdf2 [OK]
Hash vector 00: [crc32][sha1][sha256][sha512][ripemd160][whirlpool][blake2b-512][blake2s-256]
Hash vector 01: [crc32][sha1][sha256][sha512][ripemd160][whirlpool][blake2b-512][blake2s-256]
Hash vector 02: [crc32][sha1][sha256][sha512][ripemd160][whirlpool][blake2b-512][blake2s-256]
Hash vector 03: [crc32][sha1][sha256][sha512][ripemd160][whirlpool][blake2b-512][blake2s-256]
Hash vector 04: [crc32][sha1][sha256][sha512][ripemd160][whirlpool][blake2b-512][blake2s-256]
Hash vector 05: [crc32][sha1][sha256][sha512][ripemd160][whirlpool][blake2b-512][blake2s-256]
Hash vector 06: [crc32][sha1][sha256][sha512][ripemd160][whirlpool][blake2b-512][blake2s-256]
HMAC vector 00: [sha1][sha256][sha512]
HMAC vector 01: [sha1][sha256][sha512]
HMAC vector 02: [sha1][sha256][sha512]
HMAC vector 03: [sha1][sha256][sha512]
HMAC vector 04: [sha1][sha256][sha512]
HMAC vector 05: [sha1][sha256][sha512]
CIPHER vector 00: [aes-ecb,128bits][serpent-ecb N/A]
CIPHER vector 01: [aes-cbc,128bits][serpent-cbc N/A]
CIPHER vector 02: [aes-ecb,256bits][serpent-ecb N/A]
CIPHER vector 03: [aes-cbc,256bits][serpent-cbc N/A]
CIPHER vector 04: [aes-xts,256bits][serpent-xts N/A]
CIPHER vector 05: [aes-xts,512bits][serpent-xts N/A]
CIPHER vector 06: [xchacha12,aes-adiantum N/A][xchacha20,aes-adiantum N/A]
IV vector 00: [aes-cbc-null][512][1024][1024L][2048][2048L][4096][4096L]
IV vector 01: [aes-cbc-plain][512][1024][1024L][2048][2048L][4096][4096L]
IV vector 02: [aes-cbc-plain64][512][1024][1024L][2048][2048L][4096][4096L]
IV vector 03: [aes-cbc-plain64be][512][1024][1024L][2048][2048L][4096][4096L]
IV vector 04: [aes-cbc-essiv:sha256][512][1024][1024L][2048][2048L][4096][4096L]
IV vector 05: [aes-cbc-benbi][512][1024][1024L][2048][2048L][4096][4096L]
IV vector 06: [aes-cbc-eboiv][512][1024][1024L][2048][2048L][4096][4096L]
PASS: vectors-test
System PAGE_SIZE=4096
Run tests in local filesystem
# Create classic 512B drive
# (logical_block_size=512, physical_block_size=512)
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc2+
This kernel seems to not support proper scsi_debug module, test skipped.
SKIP: blockwise-compat
HEADER CHECK
 bitlk-images/bitlk-aes-cbc-128-4k.img [OK]
 bitlk-images/bitlk-aes-cbc-128.img [OK]
 bitlk-images/bitlk-aes-cbc-256.img [OK]
 bitlk-images/bitlk-aes-cbc-elephant-128.img [OK]
 bitlk-images/bitlk-aes-cbc-elephant-256.img [OK]
 bitlk-images/bitlk-aes-xts-128-4k.img [OK]
 bitlk-images/bitlk-aes-xts-128-eow.img [OK]
 bitlk-images/bitlk-aes-xts-128-new-entry.img [OK]
 bitlk-images/bitlk-aes-xts-128-smart-card.img [OK]
 bitlk-images/bitlk-aes-xts-128-startup-key.img [OK]
 bitlk-images/bitlk-aes-xts-128.img [OK]
 bitlk-images/bitlk-aes-xts-256.img [OK]
 bitlk-images/bitlk-clearkey-aes-cbc-128.img [OK]
 bitlk-images/bitlk-togo-aes-cbc-128.img [OK]
 bitlk-images/bitlk-togo-aes-xts-128.img [OK]
ACTIVATION FS UUID CHECK
 bitlk-images/bitlk-aes-cbc-128-4k.img [OK]
 bitlk-images/bitlk-aes-cbc-128-4k.img [OK]
 bitlk-images/bitlk-aes-cbc-128-4k.img [OK]
 bitlk-images/bitlk-aes-cbc-128.img [OK]
 bitlk-images/bitlk-aes-cbc-128.img [OK]
 bitlk-images/bitlk-aes-cbc-128.img [OK]
 bitlk-images/bitlk-aes-cbc-256.img [OK]
 bitlk-images/bitlk-aes-cbc-256.img [OK]
 bitlk-images/bitlk-aes-cbc-256.img [OK]
 bitlk-images/bitlk-aes-cbc-elephant-128.img [OK]
 bitlk-images/bitlk-aes-cbc-elephant-128.img [OK]
 bitlk-images/bitlk-aes-cbc-elephant-128.img [OK]
 bitlk-images/bitlk-aes-cbc-elephant-256.img [OK]
 bitlk-images/bitlk-aes-cbc-elephant-256.img [OK]
 bitlk-images/bitlk-aes-cbc-elephant-256.img [OK]
 bitlk-images/bitlk-aes-xts-128-4k.img [OK]
 bitlk-images/bitlk-aes-xts-128-4k.img [OK]
 bitlk-images/bitlk-aes-xts-128-4k.img [OK]
 bitlk-images/bitlk-aes-xts-128-eow.img [N/A]
 bitlk-images/bitlk-aes-xts-128-eow.img [N/A]
 bitlk-images/bitlk-aes-xts-128-eow.img [N/A]
 bitlk-images/bitlk-aes-xts-128-new-entry.img [OK]
 bitlk-images/bitlk-aes-xts-128-new-entry.img [OK]
 bitlk-images/bitlk-aes-xts-128-new-entry.img [OK]
 bitlk-images/bitlk-aes-xts-128-smart-card.img [OK]
 bitlk-images/bitlk-aes-xts-128-smart-card.img [OK]
 bitlk-images/bitlk-aes-xts-128-startup-key.img [OK]
 bitlk-images/bitlk-aes-xts-128-startup-key.img [OK]
 bitlk-images/bitlk-aes-xts-128-startup-key.img [OK]
 bitlk-images/bitlk-aes-xts-128.img [OK]
 bitlk-images/bitlk-aes-xts-128.img [OK]
 bitlk-images/bitlk-aes-xts-128.img [OK]
 bitlk-images/bitlk-aes-xts-256.img [OK]
 bitlk-images/bitlk-aes-xts-256.img [OK]
 bitlk-images/bitlk-aes-xts-256.img [OK]
 bitlk-images/bitlk-clearkey-aes-cbc-128.img [N/A]
 bitlk-images/bitlk-clearkey-aes-cbc-128.img [N/A]
 bitlk-images/bitlk-clearkey-aes-cbc-128.img [N/A]
 bitlk-images/bitlk-togo-aes-cbc-128.img [OK]
 bitlk-images/bitlk-togo-aes-cbc-128.img [OK]
 bitlk-images/bitlk-togo-aes-cbc-128.img [OK]
 bitlk-images/bitlk-togo-aes-xts-128.img [OK]
 bitlk-images/bitlk-togo-aes-xts-128.img [OK]
 bitlk-images/bitlk-togo-aes-xts-128.img [OK]
PASS: bitlk-compat-test
Checking dlopen(../.libs/libcryptsetup.so)...OK
Performed 120 symbol checks in total
.PASS: run-all-symbols
Cannot find dm-verity target, test skipped.
SKIP: verity-compat-test
[1] Reencryption
[2] Reencryption with data shift
[3] Reencryption with keyfile
[4] Encryption of not yet encrypted device
[5] Reencryption using specific keyslot
[6] Reencryption using all active keyslots
[7] Reencryption of block devices with different block size
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc2+
This kernel seems to not support proper scsi_debug module, test skipped.
SKIP: reencryption-compat-test
[1] Reencryption
[2] Reencryption with data shift
[3] Reencryption with keyfile
[4] Encryption of not yet encrypted device
[5] Reencryption using specific keyslot
[6] Reencryption using all active keyslots
[7] Reencryption of block devices with different block size
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc2+
This kernel seems to not support proper scsi_debug module, test skipped.
SKIP: reencryption-compat-test2
modprobe: ERROR: ../libkmod/libkmod.c:586 kmod_search_moddep() could not open moddep file '/lib/modules/5.14.0-rc2+/modules.dep.bin'
modprobe: FATAL: Module scsi_debug not found in directory /lib/modules/5.14.0-rc2+
SKIP: luks2-reencryption-test
Cannot find dm-integrity target, test skipped.
SKIP: integrity-compat-test
WARNING: Variable RUN_SSH_PLUGIN_TEST must be defined, test skipped.
SKIP: ssh-plugin-test
=======================
3 of 13 tests failed
(16 tests were not run)
=======================
make[3]: *** [Makefile:799: check-TESTS] Error 1
make[3]: Leaving directory '/root/cryptsetup/tests'
make[2]: *** [Makefile:926: check-am] Error 2
make[2]: Leaving directory '/root/cryptsetup/tests'
make[1]: *** [Makefile:928: check] Error 2
make[1]: Leaving directory '/root/cryptsetup/tests'
make: *** [Makefile:2595: check-recursive] Error 1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

