From: "Xyber Blue" <xyberblue@gmail.com>
Subject: (no subject)
Date: Tue, 5 Jun 2007 08:32:05 +0800
Message-ID: <45ea3f390706041732l7df87ecak37a1e9f506c0271b@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hello Guys,

I just want to know what are the requirements aside from the storage
subsystems hardware in creating device mapper multipath DSM or
Hardware Handler. I have just read from the linux symposium document
about the implementation of the Linux Multipathing solution that the
Device Specific Module allows the ff:

   a) Specification of kernel resident storage system specific path
group initialization
   b) IO completion filtering
   c) Message handling

Is there any document available on how to implement these specific components?

Another Question:

   How do I test these Hardware Handler in userspace?

Thanks and Best Regards,
xyber
