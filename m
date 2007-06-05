From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: [PATCH 0/3]: region based notifications for dm-io
Date: Tue, 5 Jun 2007 15:05:23 +0200
Message-ID: <5201e28f0706050605l32263e65mbc51fade00bc9e44@mail.gmail.com>
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
To: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: wein@de.ibm.com, heinzm@redhat.com
List-Id: dm-devel.ids

The following patches (based on kernel 2.6.22-rc2) will modify the
dm-io library to allow targets to get notified whenever requests to
one of the target regions changes its state. Currently this would only
be I/O completion but might include time-out notification in future.
The current implementation only handles notification events per
requests, which isn't sufficiently fine-grained for targets that want
to act sooner on I/O completion of single regions.   One intended
target will be a mirror that can go temporarily out-of-sync if one of
the mirror halves takes too much time to respond.

Regards,
Stefan Bader
