From: John Little <jslittl@hendricks.org>
Subject: multipath and san fabric
Date: Mon, 13 Nov 2006 11:35:32 -0500
Message-ID: <200611131135.32473.jslittl@hendricks.org>
Reply-To: jslittl@hendricks.org,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
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

Hi all

Admittedly this is not the correct forum for this question but I have googled 
this and the only people I have to ask around here are people who won't touch 
it because it is Linux.

My question is this:  I'm using SLES10 with two emulex hbas, one connected to 
fabric a and one to fabric b.  When zoning the switch for the hbas do I put 
in only one path to the fabric per hba or do I put in two, one to each of the 
separate fabrics?

Again I realize this is not exactly the correct forum but since I couldn't 
find an answer anywhere else I figured you guys would be the most 
knowledgeable.  If there are some docs somewhere that you could point me to I 
would appreciate it.

John
