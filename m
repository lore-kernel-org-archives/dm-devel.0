From: Bastian Blank <bastian@waldi.eu.org>
Subject: Re: __kernel_dev_t not exported
Date: Fri, 29 Jun 2007 14:16:42 +0200
Message-ID: <20070629121642.GA26471@wavehammer.waldi.eu.org>
References: <20070629121447.GA22700@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070629121447.GA22700@wavehammer.waldi.eu.org>
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

On Fri, Jun 29, 2007 at 02:14:47PM +0200, Bastian Blank wrote:
> It is pretty undefined if linux/types.h exports __kernel_dev_t (and some
> other definitions) or not. This is controlled by a define which is set
> in feature.h from the glibc (__KERNEL_STRICT_NAMES).

Forgot to say, that this breaks devmapper:
| In file included from ioctl/libdm-iface.c:22:
| ioctl/libdm-compat.h:43: error: expected specifier-qualifier-list before '__kernel_dev_t'
| ioctl/libdm-compat.h:63: error: expected specifier-qualifier-list before '__kernel_dev_t'

Bastian

-- 
Emotions are alien to me.  I'm a scientist.
		-- Spock, "This Side of Paradise", stardate 3417.3
