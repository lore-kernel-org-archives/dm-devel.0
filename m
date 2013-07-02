From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-thin btree and incremental backup issue
Date: Tue, 2 Jul 2013 09:39:45 +0100
Message-ID: <20130702083945.GA22197@debian>
References: <CAKTMprP=7G-b83cHeo4OfYSKVktm5HAdofQhJY0=LKH2=dgWpQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAKTMprP=7G-b83cHeo4OfYSKVktm5HAdofQhJY0=LKH2=dgWpQ@mail.gmail.com>
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

On Tue, Jul 02, 2013 at 10:41:31AM +0800, Teng-Feng Yang wrote:
> Hi folks,
> 
> I am currently implementing an incremental backup tool of
> dm-thin-provisioning volumes based on this post

Well done!  I've been meaning to do this for ages.  Is your code
published so I can help out?

> (https://www.redhat.com/archives/dm-devel/2012-May/msg00140.html).
> I clone the latest thin-provisioning-tools from github and use ubuntu
> 13.04 (linux 3.8.0-19) as host OS. However, as I try to perform some
> stress tests on my backup tool, I find a weird output of thin_dump
> which I cannot be sure if it is a bug or not.

Yep, it's a bug, and was fixed on Friday.

https://github.com/jthornber/thin-provisioning-tools/commit/e701b966427111f50fee21ae3d9eb5703268152c
https://github.com/jthornber/thin-provisioning-tools/commit/fe8e1592a98abc580750aaa4ad5c20a496646d4f


However I suggest you stick to the tagged 0.1.4 release (there is a
new release due in the next couple of days).

- Joe
