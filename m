From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: better alternative to part multpath -l output?
Date: Thu, 05 Jan 2012 20:24:21 +0100
Message-ID: <1325791461.19595.3.camel@lapoo.opensvc.com>
References: <4F05A6B5.1020509@UGent.be>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4F05A6B5.1020509@UGent.be>
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

On jeu., 2012-01-05 at 14:33 +0100, Rudy Gevaert wrote:
> Hello,
> 
> Can anybody suggest a better alternative to parsing multpath -l <device> 
> to get the underlying devices that are part of the multipath?
> 
"multipathd show paths format ..." maybe ?
