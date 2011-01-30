From: Milan Broz <mbroz@redhat.com>
Subject: Re: How to test the read/write flow of dm-target.
Date: Sun, 30 Jan 2011 20:27:07 +0100
Message-ID: <4D45BB8B.1000107@redhat.com>
References: <AANLkTimQjYdRqLFpuystxuN5hM=rGirj9XBiA_zDkG7+@mail.gmail.com>	<20110128194241.GB4616@us.ibm.com>
	<AANLkTikhUWPRSX87+o6BcTa8iEmh6Db0qD821ocDLV+A@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTikhUWPRSX87+o6BcTa8iEmh6Db0qD821ocDLV+A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: nishant mungse <nishantmungse@gmail.com>
List-Id: dm-devel.ids

On 01/30/2011 07:37 PM, nishant mungse wrote:
> Is there any way to find the last sector of bio.

Use csope to study kernel code, there is lot of examples
in existing code.

For last used sector in bio you probably want
last_used_sector = bio->bi_sector + bio_sectors(bio) - 1;

Milan

p.s.
Please do not post repeated questions in different threads
(and spam messages like chat invitations) to list, thank you.
