From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache - should origin device and cache be
 identical when quiescent?
Date: Fri, 23 Jan 2015 11:21:51 +0000
Message-ID: <20150123112150.GA13163@debian>
References: <CALq2s-HVaHBGY1BkBkgxmcef36H4KjTGAQoLNJk3JCE5qqe1sA@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALq2s-HVaHBGY1BkBkgxmcef36H4KjTGAQoLNJk3JCE5qqe1sA@mail.gmail.com>
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

On Fri, Jan 23, 2015 at 12:14:33PM +1000, Alex Sudakar wrote:
>   dmsetup create cache --table '0 1843200 cache /dev/vdb3 /dev/vdb2
> /dev/vdb1 64 1 writeback default 0

Use 'writethrough' rather than 'writeback'.
