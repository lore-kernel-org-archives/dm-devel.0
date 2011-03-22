From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: multipath-tools and IBM 2810 XIV
Date: Tue, 22 Mar 2011 17:42:35 +0000
Message-ID: <4D88DF8B.4020600@redhat.com>
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

Hi Folks,

Wondered if anyone had any experience with multipath-tools and the IBM XIV
storage (2810 range, possibly others)?

They look like this:

Host: scsi8 Channel: 00 Id: 01 Lun: 01
  Vendor: IBM      Model: 2810XIV          Rev: 10.1
  Type:   Direct-Access                    ANSI SCSI revision: 05

There's an IBM document that describes the configuration of these arrays under
Linux here:

http://publib.boulder.ibm.com/infocenter/ibmxiv/r2/topic/com.ibm.help.xiv.doc/docs/hsag_older_than_1_1/Host_System_Attachment_Guide_for_Linux.pdf

Which provides a multipath.conf that appears to work fine but I was wondering if
anyone has experience of using these arrays with multipath-tools - in particular
I'd like to know what the "host_connect" packages contain and whether you can
avoid installing them with a few manual steps.

Regards,
Bryn.
