From: "Pradipmaya Maharana" <pradipmaya@gmail.com>
Subject: Problem with DM hardware handler
Date: Mon, 29 Oct 2007 16:45:01 -0700
Message-ID: <110b17190710291645l42e98bc5i6089102bb1e15f9@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi All,

I am writing a DM Hardware handler; so to start with I took, dm-emc.c
code and replaced emc by sample. I also renamed the file to dm-sample
and the module name is dm-sample.ko.

The code compiles fine and even loads okay. I modiefied the
/etc/multipath.conf to point the hardware_handler to my sample
handler.

 hardware_handler        "1 sample"

Now when I run the command,
# multipath -F
# multipath -ll
# multipath -v3

It shows me the following error in the /var/log/messages
Oct 29 16:33:23 localhost kernel: device-mapper: table: 253:0:
multipath: unknown hardware handler type
Oct 29 16:33:23 localhost kernel: device-mapper: ioctl: error adding
target to table

Same works fine, if I add emc as hardware handler.

Any idea, why am I getting this error?

Thanks and Regards,
Pradipmaya.
