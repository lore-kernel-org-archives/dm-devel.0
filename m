From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: multipathd init script errors
Date: Tue, 14 Apr 2009 09:29:08 +0530
Message-ID: <d9edb6-5gh.ln1@news.researchut.com>
References: <1239620726.30476.3.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7Bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

John A. Sullivan III wrote:

> /etc/init.d/multipathd: line 33: cd: HOME not set
> /etc/init.d/multipathd: line 51: read: read error: 0: Is a directory
> 
> Any idea how we fix this? Thanks - John
> 
Hi John,

I think you are running the SLES distribution.
This mailing list is for upstream development of Device Mapper and 
Multipath. Upstream doesn't maintain init scripts any more.

Probably SLES's support channel should be the right place to look for help.

Ritesh
-- 
If possible, Please CC me when replying. I'm not subscribed to the list.
