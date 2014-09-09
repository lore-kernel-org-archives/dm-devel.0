From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache caching network volume
Date: Tue, 9 Sep 2014 16:47:25 +0100
Message-ID: <20140909154723.GB2967@debian>
References: <1371547972.6128.8.camel@expiron>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1371547972.6128.8.camel@expiron>
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

On Tue, Jun 18, 2013 at 11:32:52AM +0200, =C9tienne BERSAC wrote:
> Is it possible to have dm-cache "bufferize" blocks for network
> failures ?

dm-cache is a slow moving cache, foor instance, it does not attempt to
pass all writes through the SSD.  Since you cannot rule out IO going
to the origin device it's not suitable for adding resilience to an
intermittent network connection.  Perhaps you should look at dm-raid?

- Joe
