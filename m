From: "Navin P.S" <navinp1912@gmail.com>
Subject: write directly to device mapper snapshot origin device ?
Date: Thu, 14 Jul 2016 19:55:25 +0530
Message-ID: <CAA=4086wdhAxNsWjAYgZG3bWORV2vF3YpMQk9OTjAg22MJi07Q@mail.gmail.com>
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
  Can i do dd if=/dev/zero of=/dev/mapper/dmo count=20 ? where dmo is
a dm snapshot origin created through dmsetup command. Instead of
/dev/zero i can write valid devices.

I could create the dmo through some lvm2 commands. Is direct write
with 4k (page size values ) allowed when it is mapped to 2 block
devices in linear mode ?


Regards,
-- Navin
