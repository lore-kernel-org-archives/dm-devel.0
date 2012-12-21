From: Greg Stark <stark@mit.edu>
Subject: How to force a snapshot status to valid when I know very
	well it's valid?
Date: Fri, 21 Dec 2012 18:31:54 +0000
Message-ID: <CAM-w4HM0-Cov_KtRE410etrh+v795tsPX1UM9WkV-o4MXaQBAQ@mail.gmail.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

I have a snapshot whose cow table became full. I understand full well
why snapshots become invalid at this point but the source volume was
not mounted anywhere and hasn't been written to. I can add more space
to the cow table now but is there any way to force the status to be
valid again?

-- 
greg
