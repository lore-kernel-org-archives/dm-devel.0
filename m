From: Busby <chaimvy@gmail.com>
Subject: Does dm-thin support GC (garbage collection) ?
Date: Mon, 7 May 2012 15:28:30 +0800
Message-ID: <CAJv3x-Xk-aODfJtqCEBKPM1jkwXEFVN40EEu_hnnDZB9o4dBWw@mail.gmail.com>
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
         The dm-thin supports 'discard' now?Can I think this function
likes SSD's 'TRIM'? If it just discard the block mapped but not
remap(reallocate), the Pool's space will soon be used up . I want to
know whether it supports block reuse ( can use ext4 with '--discard'
test this? ) now or in the future.
        Thanks.


Best regards,
Busby
