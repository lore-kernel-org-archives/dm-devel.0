From: Joe Thornber <thornber@redhat.com>
Subject: Re: [Question] dm-cache table
Date: Mon, 25 Nov 2013 12:05:12 +0000
Message-ID: <20131125120512.GC10831@debian>
References: <52932C6F.5000306@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <52932C6F.5000306@gmail.com>
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

On Mon, Nov 25, 2013 at 07:54:39PM +0900, Akira Hayakawa wrote:
> If it accepted migrate_threshold in .ctr and the parameter
> changed later. The actual value and what is seen in table
> become inconsistent right? Is this intentionally designed?

No, this is a bug.

> If table is just the copy of the ctr args,
> why don't we implement it in dm framework?

It has been discussed.  Originally the target were so simple it was
easy to generate a new table line.  Creating copies of the table
params only happened recently with the more complicated targets.  We
could have some infrastructure provided by the dm core for this, but
we can't use it blindly as your bug above demonstrates.

- Joe
