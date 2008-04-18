From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: path checker open() flags, devmapper ioctl()
Date: Fri, 18 Apr 2008 21:43:01 +0200
Message-ID: <1208547781.11770.117.camel@plop>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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

Here is an update with my findings of today.

Paths to R2 LU are flaged read-only upon detection, as can be seen with
"hdparm -r". hdparm is able to flag them rw (hdparm -r0). Once paths are
switched to rw, I still can't use multipath to load maps upon them.

But, issuing "blockdev --rereadpt" on the paths finally resolves this
issue.

I'm confused. What is expected from the multipath tools there ? I'd like
to have the multipath maps up and running for R2 LU, for them to be
ready the moment they get activated by the R1/R2 split. But I'm not sure
how to do that in the described context. Input welcome.

Regards,
cvaroqui
