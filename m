From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: dm-multipath test scripts
Date: Fri, 19 Feb 2016 08:37:46 +0000
Message-ID: <56C6D45A.6060407@ce.jp.nec.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com> <56C662F1.8070407@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <56C662F1.8070407@ce.jp.nec.com>
Content-Language: ja-JP
Content-ID: <A12F6279FB0BD14D8E7A85DA5B22E73D@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: dm-devel.ids

On 02/19/16 09:33, Nomura Junichi wrote:
> On 02/19/16 02:17, Mike Snitzer wrote:
>> What is the last kernel version that your scripts have worked on?
> 
> v4.4 worked fine. I'll check with v4.5-rc4 when I get a machine.

v4.5-rc4 works fine, too.

So if all tests fail for you, it might be due to difference in
environment or kernel config.
I'm running tests on RHEL7.2 and kernel config is based on RHEL7 kernel.

# rpm -q targetcli
targetcli-2.1.fb41-3.el7.noarch
# cp /boot/config-3.10.0-327.el7.x86_64 .config
# make olddefconfig
...

-- 
Jun'ichi Nomura, NEC Corporation
