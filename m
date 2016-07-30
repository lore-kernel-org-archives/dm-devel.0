From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 16/18] multipath-tools: Use ALUA for HP 3PAR
Date: Sun, 31 Jul 2016 01:39:23 +0200
Message-ID: <aeee838a-6d44-ee76-62c5-4d97cbcaca80@gmail.com>
References: <1469838506-15689-1-git-send-email-xose.vazquez@gmail.com>
	<1469838506-15689-16-git-send-email-xose.vazquez@gmail.com>
	<trinity-e6c25fb4-7664-4f5d-9885-5aba45504689-1469916891284@3capp-gmx-bs13>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <trinity-e6c25fb4-7664-4f5d-9885-5aba45504689-1469916891284@3capp-gmx-bs13>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 07/31/2016 12:14 AM, Sebastian Herbszt wrote:

> Xose Vazquez Perez wrote:

>> Sebastian was not convinced with this change, full thread: https://marc.info/?t=146175638600002
>> But there is no automatic way to change .pgpolicy from MULTIBUS to GROUP_BY_PRIO.
>> So we should stick to latest manufacturer's recommendations:

> So 'retain_attached_hw_handler' suggested by Hannes doesn't work?

No. It's related to hardware_handler, "alua" in this case.
