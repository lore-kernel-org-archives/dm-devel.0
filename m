From: Busby <chaimvy@gmail.com>
Subject: How to control the device mapper 's memory use?(or the
 IO queue limits?)
Date: Thu, 12 Jul 2012 18:14:43 +0800
Message-ID: <CAJv3x-XF-E4uxnr7CCRUFV0je4cr2GQRPWAhnjwwxUtK3xkGQg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi All,
         I created  a thin-lun using dm-thin module. When used the
'dd' cmd to write to the thin lun ( the memory of my server is 10G, dd
file size is 50G, thin lun size is 100G ), only 60M was free. Then I
used 'iostat' to see how many io the dm device blocked, the number was
more than 1,000,000. Does the device mapper limit the mapped device's
queue? If not, how can limit the memory use, if we use writ-back, more
and more io will be mapped to the thin target?
      Is there any way to limit the mapped device 's request queue(or
it has been done)? I test the shared-snapshot(Mikulas), 'dd' the
origin volume(has snap volume ), big part of the memory will be used
and the IO number of the dm device is very big (use 'iostat').
      Thanks.

Best Wishes & Regards,

Busby
