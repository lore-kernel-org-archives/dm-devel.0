From: malahal@us.ibm.com
Subject: Re: simple question... to tough to answer?
Date: Thu, 15 May 2008 10:46:29 -0700
Message-ID: <20080515174629.GA8808@us.ibm.com>
References: <7BC3A7DB53028743B733D298244A8C626E3A0D@sjcpexch02.citrite.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <7BC3A7DB53028743B733D298244A8C626E3A0D@sjcpexch02.citrite.net>
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

Wim Colgate [Wim.Colgate@citrix.com] wrote:
>    Hi,
> 
    Simply (re)stated:
>    1) Are there hooks for dm/multipath events to notify software?

Not that I know of, but multipath uses uevets, so you can have your own
daemon listening.
