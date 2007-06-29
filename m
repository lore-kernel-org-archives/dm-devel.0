From: Bastian Blank <bastian@waldi.eu.org>
Subject: __kernel_dev_t not exported
Date: Fri, 29 Jun 2007 14:14:47 +0200
Message-ID: <20070629121447.GA22700@wavehammer.waldi.eu.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi folks

It is pretty undefined if linux/types.h exports __kernel_dev_t (and some
other definitions) or not. This is controlled by a define which is set
in feature.h from the glibc (__KERNEL_STRICT_NAMES).

Some arches include feature.h in the gcc headers, some not.

I'm not sure if this should be fixed in the kernel. Userspace should
never see this standard definitions (dev_t, mode_t, off_t and so on).

Bastian

-- 
Extreme feminine beauty is always disturbing.
		-- Spock, "The Cloud Minders", stardate 5818.4
