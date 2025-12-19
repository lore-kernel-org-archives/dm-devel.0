Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A5B4A33
	for <dm-devel@lists.linux.dev>; Fri, 19 Dec 2025 00:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766104700; cv=none; b=kVr7AUa8KxG9neqRdVY4uTyiKZOgy59Q9NOXC8V7xX33+Vafe2QJ8L/d2qa1P+My9yHwLS9FuLblIslvpNH1O20nr8ajuYEr9Q3kOG6g8vDcB81/OP8CNGgZj3ujh0URLuA2YycqVXDlyz2/38gsGtMElB4plHyRA7rS3Bfwf7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766104700; c=relaxed/simple;
	bh=Vll+oSmo+UNQHmZ7fS/uUa4M6mtG3m9iqHWlqXOHnHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=FsCgoCgEK4VLMvGIEx1e7U1A6Q/MACS1icVTPeK3aWxfeYlIGZ/oULKpcfUYX0ju9v51a1w1unuY9f7B9z8DVt9WcWZu3++7BsiPURqRxO4AI19QmuT55f38NGwQetgDzKqaHb2jNI7AsRP2P24xomDKsA29f9y1HMgRWjzSnjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DC7I0kN0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DC7I0kN0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766104696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QRPq28wj2bh3n7gIzFC2NLgo5xSLxni/A10SuxcskKM=;
	b=DC7I0kN0p6YrXF30HbsQ87OVxVyMIvY5QxzAxjNK27w/ZTdF7xeF2qeq4XWdVRvGQOHEU5
	NJR+1pTeWDcCxwHKcAd4TNeeD64mB3nIS2t8UdD99bIi37zlDHIkulxYiW4qiQXgBX3UOC
	futj90XjkqWBNITaUWJlLq7vQPvmPmE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-thVFCWFhOnu-zp-ov0QKEw-1; Thu,
 18 Dec 2025 19:38:14 -0500
X-MC-Unique: thVFCWFhOnu-zp-ov0QKEw-1
X-Mimecast-MFC-AGG-ID: thVFCWFhOnu-zp-ov0QKEw_1766104693
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF2511956046;
	Fri, 19 Dec 2025 00:38:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3BD14180045B;
	Fri, 19 Dec 2025 00:38:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5BJ0cC3k2124854
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 19:38:12 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5BJ0cCaj2124853;
	Thu, 18 Dec 2025 19:38:12 -0500
Date: Thu, 18 Dec 2025 19:38:12 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 18/21] libmpathutil: add wrapper code for libudev
Message-ID: <aUSedLFHsg6xRGRR@redhat.com>
References: <20251217212113.234959-1-mwilck@suse.com>
 <20251217212113.234959-19-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20251217212113.234959-19-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xvzq1iWaFyshUFDPPPAxD6wwtpZ0SbqhRrnKVWdhtAI_1766104693
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2025 at 10:21:10PM +0100, Martin Wilck wrote:
> The libudev documentation [1] states that libudev is not thread-safe and
> shouldn't be used from multithreaded programs. While the man page also
> states that using libudev in multithreaded programs is unsafe even if
> locking is used, there's not much else we can do in multipath-tools to
> mitigate the problem, as we are using libudev in multiple threads all over
> the place.

Ugh. I'm a little confused on what exactly could go wrong. Do you know
what they are concerned with, that locking cannot fix? It sounds like
the functions themselves are safe to call from multiple threads, as long
as they are working on separate data. If they were manipulating global
state that wouldn't be true.

> Add wrapper code that wraps all calls to libudev in a critical section
> holding a specific mutex.
> 
> [1] https://man7.org/linux/man-pages/man3/libudev.3.html

I assume that there must be times when use call a udev outside of the
vecs lock. Did you check how often that is? Not that would be great to
pile even more work on the vecs lock.

Also, git flagged some whitespace errors.

> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathutil/libmpathutil.version |  62 +++
>  libmpathutil/mt-libudev.c         | 776 ++++++++++++++++++++++++++++++
>  libmpathutil/mt-libudev.h         | 120 +++++
>  libmpathutil/mt-udev-wrap.h       |  90 ++++
>  4 files changed, 1048 insertions(+)
>  create mode 100644 libmpathutil/mt-libudev.c
>  create mode 100644 libmpathutil/mt-libudev.h
>  create mode 100644 libmpathutil/mt-udev-wrap.h
> 
> diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
> index 14aa083..4ce1da6 100644
> --- a/libmpathutil/libmpathutil.version
> +++ b/libmpathutil/libmpathutil.version
> @@ -93,6 +93,68 @@ global:
>  	log_thread_stop;
>  	logsink;
>  	msort;
> +
> +        mt_udev_ref;
> +        mt_udev_unref;
> +        mt_udev_new;
> +
> +        mt_udev_list_entry_get_next;
> +        mt_udev_list_entry_get_by_name;
> +        mt_udev_list_entry_get_name;
> +        mt_udev_list_entry_get_value;
> +
> +        mt_udev_device_ref;
> +        mt_udev_device_unref;
> +        
> +        mt_udev_device_new_from_syspath;
> +        mt_udev_device_new_from_devnum;
> +        mt_udev_device_new_from_subsystem_sysname;
> +        mt_udev_device_new_from_device_id;
> +        mt_udev_device_new_from_environment;
> +
> +        mt_udev_device_get_udev;
> +        mt_udev_device_get_parent;
> +        mt_udev_device_get_parent_with_subsystem_devtype;
> +        mt_udev_device_get_devpath;
> +        mt_udev_device_get_subsystem;
> +	mt_udev_device_get_devtype;
> +        mt_udev_device_get_syspath;
> +        mt_udev_device_get_sysname;
> +        mt_udev_device_get_devnum;
> +        mt_udev_device_get_is_initialized;
> +        mt_udev_device_get_property_value;
> +        mt_udev_device_get_seqnum;
> +        mt_udev_device_set_sysattr_value;
> +        mt_udev_device_get_sysattr_value;
> +        mt_udev_device_get_driver;
> +        mt_udev_device_get_devnode;
> +        
> +        mt_udev_device_get_properties_list_entry;
> +
> +        mt_udev_monitor_new_from_netlink;
> +        mt_udev_monitor_enable_receiving;
> +        mt_udev_monitor_get_fd;
> +        mt_udev_monitor_receive_device;
> +        mt_udev_monitor_filter_add_match_subsystem_devtype;
> +        mt_udev_monitor_ref;
> +        mt_udev_monitor_unref;
> +        mt_udev_monitor_set_receive_buffer_size;
> +
> +        mt_udev_enumerate_new;
> +        mt_udev_enumerate_ref;
> +        mt_udev_enumerate_unref;
> +        mt_udev_enumerate_add_match_subsystem;
> +        mt_udev_enumerate_scan_devices;
> +        mt_udev_enumerate_get_list_entry;
> +	mt_udev_enumerate_add_nomatch_subsystem;
> +        mt_udev_enumerate_add_match_sysattr;
> +        mt_udev_enumerate_add_nomatch_sysattr;
> +        mt_udev_enumerate_add_match_property;
> +        mt_udev_enumerate_add_match_tag;
> +        mt_udev_enumerate_add_match_parent;
> +        mt_udev_enumerate_add_match_is_initialized;
> +        mt_udev_enumerate_add_syspath;
> +	
>  	normalize_timespec;
>  	parse_devt;
>  	print_strbuf;
> diff --git a/libmpathutil/mt-libudev.c b/libmpathutil/mt-libudev.c
> new file mode 100644
> index 0000000..2e37c7d
> --- /dev/null
> +++ b/libmpathutil/mt-libudev.c
> @@ -0,0 +1,776 @@
> +#include "mt-libudev.h"
> +#include <stddef.h>
> +#include <libudev.h>
> +#include "util.h"
> +
> +static pthread_mutex_t libudev_mutex = PTHREAD_MUTEX_INITIALIZER;
> +
> +struct udev *mt_udev_ref(struct udev *udev)
> +{
> +	struct udev *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_ref(udev);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev *mt_udev_unref(struct udev *udev)
> +{
> +	struct udev *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_unref(udev);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev *mt_udev_new(void)
> +{
> +	struct udev *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_new();
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_list_entry *mt_udev_list_entry_get_next(struct udev_list_entry *list_entry)
> +{
> +	struct udev_list_entry *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_list_entry_get_next(list_entry);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_list_entry *
> +mt_udev_list_entry_get_by_name(struct udev_list_entry *list_entry, const char *name)
> +{
> +	struct udev_list_entry *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_list_entry_get_by_name(list_entry, name);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_list_entry_get_name(struct udev_list_entry *list_entry)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_list_entry_get_name(list_entry);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_list_entry_get_value(struct udev_list_entry *list_entry)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_list_entry_get_value(list_entry);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *
> +mt_udev_device_new_from_syspath(struct udev *udev, const char *syspath)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_new_from_syspath(udev, syspath);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *
> +mt_udev_device_new_from_devnum(struct udev *udev, char type, dev_t devnum)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_new_from_devnum(udev, type, devnum);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *
> +mt_udev_device_new_from_subsystem_sysname(struct udev *udev, const char *subsystem,
> +					  const char *sysname)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_new_from_subsystem_sysname(udev, subsystem, sysname);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *mt_udev_device_new_from_device_id(struct udev *udev, char *id)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_new_from_device_id(udev, id);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *mt_udev_device_new_from_environment(struct udev *udev)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_new_from_environment(udev);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *mt_udev_device_ref(struct udev_device *udev_device)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_ref(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *mt_udev_device_unref(struct udev_device *udev_device)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_unref(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev *mt_udev_device_get_udev(struct udev_device *udev_device)
> +{
> +	struct udev *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_udev(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *mt_udev_device_get_parent(struct udev_device *udev_device)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_parent(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *mt_udev_device_get_parent_with_subsystem_devtype(
> +	struct udev_device *udev_device, const char *subsystem, const char *devtype)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_parent_with_subsystem_devtype(udev_device,
> +							    subsystem, devtype);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_device_get_devpath(struct udev_device *udev_device)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_devpath(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_device_get_subsystem(struct udev_device *udev_device)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_subsystem(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_device_get_devtype(struct udev_device *udev_device)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_devtype(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_device_get_syspath(struct udev_device *udev_device)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_syspath(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_device_get_sysname(struct udev_device *udev_device)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_sysname(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +dev_t mt_udev_device_get_devnum(struct udev_device *udev_device)
> +{
> +	dev_t ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_devnum(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +unsigned long long mt_udev_device_get_seqnum(struct udev_device *udev_device)
> +{
> +	unsigned long long ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_seqnum(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_device_get_driver(struct udev_device *udev_device)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_driver(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_device_get_devnode(struct udev_device *udev_device)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_devnode(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_device_get_is_initialized(struct udev_device *udev_device)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_is_initialized(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *
> +mt_udev_device_get_property_value(struct udev_device *udev_device, const char *key)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_property_value(udev_device, key);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +const char *mt_udev_device_get_sysattr_value(struct udev_device *udev_device,
> +					     const char *sysattr)
> +{
> +	const char *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_sysattr_value(udev_device, sysattr);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_device_set_sysattr_value(struct udev_device *udev_device,
> +				     const char *sysattr, char *value)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_set_sysattr_value(udev_device, sysattr, value);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_list_entry *
> +mt_udev_device_get_properties_list_entry(struct udev_device *udev_device)
> +{
> +	struct udev_list_entry *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_device_get_properties_list_entry(udev_device);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +/*
> + * multipath-tools doesn't use these, and some of them aren't available
> + * in older libudev versions. Keeping the code here in case we will
> + * need it in the future.
> +
> +struct udev_list_entry *mt_udev_device_get_devlinks_list_entry(struct
> +udev_device *udev_device)
> +{
> +    struct udev_list_entry *ret;
> +    pthread_mutex_lock(&libudev_mutex);
> +    pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +    ret = udev_device_get_devlinks_list_entry(udev_device);
> +
> +    pthread_cleanup_pop(1);
> +    return ret;
> +}
> +
> +struct udev_list_entry *mt_udev_device_get_tags_list_entry(struct udev_device
> +*udev_device)
> +{
> +    struct udev_list_entry *ret;
> +    pthread_mutex_lock(&libudev_mutex);
> +    pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +    ret = udev_device_get_tags_list_entry(udev_device);
> +
> +    pthread_cleanup_pop(1);
> +    return ret;
> +}
> +
> +struct udev_list_entry *mt_udev_device_get_current_tags_list_entry(struct
> +udev_device *udev_device)
> +{
> +    struct udev_list_entry *ret;
> +    pthread_mutex_lock(&libudev_mutex);
> +    pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +    ret = udev_device_get_current_tags_list_entry(udev_device);
> +
> +    pthread_cleanup_pop(1);
> +    return ret;
> +}
> +
> +struct udev_list_entry *mt_udev_device_get_sysattr_list_entry(struct
> +udev_device *udev_device)
> +{
> +    struct udev_list_entry *ret;
> +    pthread_mutex_lock(&libudev_mutex);
> +    pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +    ret = udev_device_get_sysattr_list_entry(udev_device);
> +
> +    pthread_cleanup_pop(1);
> +    return ret;
> +}
> +*/
> +
> +struct udev_monitor *
> +mt_udev_monitor_new_from_netlink(struct udev *udev, const char *name)
> +{
> +	struct udev_monitor *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_monitor_new_from_netlink(udev, name);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_monitor *mt_udev_monitor_ref(struct udev_monitor *udev_monitor)
> +{
> +	struct udev_monitor *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_monitor_ref(udev_monitor);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_monitor *mt_udev_monitor_unref(struct udev_monitor *udev_monitor)
> +{
> +	struct udev_monitor *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_monitor_unref(udev_monitor);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_monitor_enable_receiving(struct udev_monitor *udev_monitor)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_monitor_enable_receiving(udev_monitor);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_monitor_get_fd(struct udev_monitor *udev_monitor)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_monitor_get_fd(udev_monitor);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_device *mt_udev_monitor_receive_device(struct udev_monitor *udev_monitor)
> +{
> +	struct udev_device *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_monitor_receive_device(udev_monitor);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_monitor_filter_add_match_subsystem_devtype(
> +	struct udev_monitor *udev_monitor, const char *subsystem, const char *devtype)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_monitor_filter_add_match_subsystem_devtype(udev_monitor,
> +							      subsystem, devtype);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_monitor_set_receive_buffer_size(struct udev_monitor *udev_monitor, int size)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_monitor_set_receive_buffer_size(udev_monitor, size);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_enumerate *mt_udev_enumerate_new(struct udev *udev)
> +{
> +	struct udev_enumerate *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_new(udev);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_enumerate *mt_udev_enumerate_ref(struct udev_enumerate *udev_enumerate)
> +{
> +	struct udev_enumerate *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_ref(udev_enumerate);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_enumerate *mt_udev_enumerate_unref(struct udev_enumerate *udev_enumerate)
> +{
> +	struct udev_enumerate *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_unref(udev_enumerate);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_add_match_subsystem(struct udev_enumerate *udev_enumerate,
> +					  const char *subsystem)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_add_match_subsystem(udev_enumerate, subsystem);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_add_nomatch_subsystem(struct udev_enumerate *udev_enumerate,
> +					    const char *subsystem)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_add_nomatch_subsystem(udev_enumerate, subsystem);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_add_match_sysattr(struct udev_enumerate *udev_enumerate,
> +					const char *sysattr, const char *value)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_add_match_sysattr(udev_enumerate, sysattr, value);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_add_nomatch_sysattr(struct udev_enumerate *udev_enumerate,
> +					  const char *sysattr, const char *value)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_add_nomatch_sysattr(udev_enumerate, sysattr, value);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_add_match_property(struct udev_enumerate *udev_enumerate,
> +					 const char *property, const char *value)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_add_match_property(udev_enumerate, property, value);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_add_match_tag(struct udev_enumerate *udev_enumerate,
> +				    const char *tag)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_add_match_tag(udev_enumerate, tag);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_add_match_parent(struct udev_enumerate *udev_enumerate,
> +				       struct udev_device *parent)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_add_match_parent(udev_enumerate, parent);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_add_match_is_initialized(struct udev_enumerate *udev_enumerate)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_add_match_is_initialized(udev_enumerate);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_add_syspath(struct udev_enumerate *udev_enumerate,
> +				  const char *syspath)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_add_syspath(udev_enumerate, syspath);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +int mt_udev_enumerate_scan_devices(struct udev_enumerate *udev_enumerate)
> +{
> +	int ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_scan_devices(udev_enumerate);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> +
> +struct udev_list_entry *
> +mt_udev_enumerate_get_list_entry(struct udev_enumerate *udev_enumerate)
> +{
> +	struct udev_list_entry *ret;
> +
> +	pthread_mutex_lock(&libudev_mutex);
> +	pthread_cleanup_push(cleanup_mutex, &libudev_mutex);
> +
> +	ret = udev_enumerate_get_list_entry(udev_enumerate);
> +
> +	pthread_cleanup_pop(1);
> +	return ret;
> +}
> diff --git a/libmpathutil/mt-libudev.h b/libmpathutil/mt-libudev.h
> new file mode 100644
> index 0000000..1c1e748
> --- /dev/null
> +++ b/libmpathutil/mt-libudev.h
> @@ -0,0 +1,120 @@
> +#ifndef MT_LIBUDEV_H
> +#define MT_LIBUDEV_H
> +
> +#include <pthread.h>
> +#include <stdarg.h>    /* for va_list */
> +#include <sys/types.h> /* For dev_t */
> +
> +struct udev;
> +struct udev_list_entry;
> +struct udev_device;
> +struct udev_monitor;
> +struct udev_enumerate;
> +
> +struct udev *mt_udev_ref(struct udev *udev);
> +struct udev *mt_udev_unref(struct udev *udev);
> +struct udev *mt_udev_new(void);
> +
> +struct udev_list_entry *
> +mt_udev_list_entry_get_next(struct udev_list_entry *list_entry);
> +struct udev_list_entry *
> +mt_udev_list_entry_get_by_name(struct udev_list_entry *list_entry, const char *name);
> +const char *mt_udev_list_entry_get_name(struct udev_list_entry *list_entry);
> +const char *mt_udev_list_entry_get_value(struct udev_list_entry *list_entry);
> +
> +struct udev_device *
> +mt_udev_device_new_from_syspath(struct udev *udev, const char *syspath);
> +struct udev_device *
> +mt_udev_device_new_from_devnum(struct udev *udev, char type, dev_t devnum);
> +struct udev_device *
> +mt_udev_device_new_from_subsystem_sysname(struct udev *udev, const char *subsystem,
> +					  const char *sysname);
> +/*
> + * Some older libudev versions  don't use "const" for the id argument,
> + * therefore we can't use it here, either.
> + */
> +struct udev_device *mt_udev_device_new_from_device_id(struct udev *udev, char *id);
> +struct udev_device *mt_udev_device_new_from_environment(struct udev *udev);
> +
> +struct udev_device *mt_udev_device_ref(struct udev_device *udev_device);
> +struct udev_device *mt_udev_device_unref(struct udev_device *udev_device);
> +struct udev *mt_udev_device_get_udev(struct udev_device *udev_device);
> +struct udev_device *mt_udev_device_get_parent(struct udev_device *udev_device);
> +struct udev_device *mt_udev_device_get_parent_with_subsystem_devtype(
> +	struct udev_device *udev_device, const char *subsystem,
> +	const char *devtype);
> +const char *mt_udev_device_get_devpath(struct udev_device *udev_device);
> +const char *mt_udev_device_get_subsystem(struct udev_device *udev_device);
> +const char *mt_udev_device_get_devtype(struct udev_device *udev_device);
> +const char *mt_udev_device_get_syspath(struct udev_device *udev_device);
> +const char *mt_udev_device_get_sysname(struct udev_device *udev_device);
> +int mt_udev_device_get_is_initialized(struct udev_device *udev_device);
> +const char *
> +mt_udev_device_get_property_value(struct udev_device *udev_device, const char *key);
> +dev_t mt_udev_device_get_devnum(struct udev_device *udev_device);
> +unsigned long long int mt_udev_device_get_seqnum(struct udev_device *udev_device);
> +const char *mt_udev_device_get_driver(struct udev_device *udev_device);
> +const char *mt_udev_device_get_devnode(struct udev_device *udev_device);
> +const char *mt_udev_device_get_sysattr_value(struct udev_device *udev_device,
> +					     const char *sysattr);
> +/*
> + * libudev-215 (Debian jessie) doesn't use "const" for the value argument,
> + * therefore we can't use it here, either.
> + */
> +int mt_udev_device_set_sysattr_value(struct udev_device *udev_device,
> +				     const char *sysattr, char *value);
> +
> +struct udev_list_entry *
> +mt_udev_device_get_properties_list_entry(struct udev_device *udev_device);
> +/*
> + * multipath-tools doesn't use these, and some of them aren't available
> + * in older libudev versions.
> +
> + struct udev_list_entry *mt_udev_device_get_devlinks_list_entry(struct
> + udev_device *udev_device); struct udev_list_entry
> + *mt_udev_device_get_tags_list_entry(struct udev_device *udev_device); struct
> + udev_list_entry *mt_udev_device_get_current_tags_list_entry(struct udev_device
> + *udev_device); struct udev_list_entry
> + *mt_udev_device_get_sysattr_list_entry(struct udev_device *udev_device);
> +*/
> +struct udev_monitor *
> +mt_udev_monitor_new_from_netlink(struct udev *udev, const char *name);
> +struct udev_monitor *mt_udev_monitor_ref(struct udev_monitor *udev_monitor);
> +struct udev_monitor *mt_udev_monitor_unref(struct udev_monitor *udev_monitor);
> +int mt_udev_monitor_enable_receiving(struct udev_monitor *udev_monitor);
> +int mt_udev_monitor_get_fd(struct udev_monitor *udev_monitor);
> +struct udev_device *
> +mt_udev_monitor_receive_device(struct udev_monitor *udev_monitor);
> +int mt_udev_monitor_filter_add_match_subsystem_devtype(
> +	struct udev_monitor *udev_monitor, const char *subsystem,
> +	const char *devtype);
> +int mt_udev_monitor_set_receive_buffer_size(struct udev_monitor *udev_monitor,
> +					    int size);
> +
> +struct udev_enumerate *mt_udev_enumerate_new(struct udev *udev);
> +struct udev_enumerate *mt_udev_enumerate_ref(struct udev_enumerate *udev_enumerate);
> +struct udev_enumerate *
> +mt_udev_enumerate_unref(struct udev_enumerate *udev_enumerate);
> +int mt_udev_enumerate_add_match_subsystem(struct udev_enumerate *udev_enumerate,
> +					  const char *subsystem);
> +int mt_udev_enumerate_add_nomatch_subsystem(struct udev_enumerate *udev_enumerate,
> +					    const char *subsystem);
> +int mt_udev_enumerate_add_match_sysattr(struct udev_enumerate *udev_enumerate,
> +					const char *sysattr, const char *value);
> +int mt_udev_enumerate_add_nomatch_sysattr(struct udev_enumerate *udev_enumerate,
> +					  const char *sysattr, const char *value);
> +int mt_udev_enumerate_add_match_property(struct udev_enumerate *udev_enumerate,
> +					 const char *property, const char *value);
> +int mt_udev_enumerate_add_match_tag(struct udev_enumerate *udev_enumerate,
> +				    const char *tag);
> +int mt_udev_enumerate_add_match_parent(struct udev_enumerate *udev_enumerate,
> +				       struct udev_device *parent);
> +int mt_udev_enumerate_add_match_is_initialized(struct udev_enumerate *udev_enumerate);
> +int mt_udev_enumerate_add_syspath(struct udev_enumerate *udev_enumerate,
> +				  const char *syspath);
> +int mt_udev_enumerate_scan_devices(struct udev_enumerate *udev_enumerate);
> +int mt_udev_enumerate_scan_subsystems(struct udev_enumerate *udev_enumerate);
> +struct udev_list_entry *
> +mt_udev_enumerate_get_list_entry(struct udev_enumerate *udev_enumerate);
> +
> +#endif
> diff --git a/libmpathutil/mt-udev-wrap.h b/libmpathutil/mt-udev-wrap.h
> new file mode 100644
> index 0000000..f232821
> --- /dev/null
> +++ b/libmpathutil/mt-udev-wrap.h
> @@ -0,0 +1,90 @@
> +#ifndef MT_LIBUDEV_WRAP_HPP
> +#define MT_LIBUDEV_WRAP_HPP
> +#include "mt-libudev.h"
> +
> +#define udev_ref(udev)                       mt_udev_ref(udev)
> +#define udev_unref(udev)                     mt_udev_unref(udev)
> +#define udev_new()                           mt_udev_new()
> +
> +#define udev_list_entry_get_next(list_entry)             mt_udev_list_entry_get_next(list_entry)
> +#define udev_list_entry_get_by_name(list_entry, name)    mt_udev_list_entry_get_by_name(list_entry, name)
> +#define udev_list_entry_get_name(list_entry)             mt_udev_list_entry_get_name(list_entry)
> +#define udev_list_entry_get_value(list_entry)            mt_udev_list_entry_get_value(list_entry)
> +
> +#define udev_list_entry_foreach(list_entry, first_entry)	\
> +        for (list_entry = first_entry; \
> +             list_entry; \
> +             list_entry = udev_list_entry_get_next(list_entry))
> +
> +#define udev_device_new_from_syspath(udev, syspath)               mt_udev_device_new_from_syspath(udev, syspath)
> +#define udev_device_new_from_devnum(udev, type, devnum)           mt_udev_device_new_from_devnum(udev, type, devnum)
> +#define udev_device_new_from_subsystem_sysname(udev, subsystem, sysname) \
> +                                                                  mt_udev_device_new_from_subsystem_sysname(udev, subsystem, sysname)
> +#define udev_device_new_from_device_id(udev, id) mt_udev_device_new_from_device_id(udev, id)
> +#define udev_device_new_from_environment(udev)                    mt_udev_device_new_from_environment(udev)
> +
> +#define udev_device_ref(udev_device)                      mt_udev_device_ref(udev_device)
> +#define udev_device_unref(udev_device)                    mt_udev_device_unref(udev_device)
> +#define udev_device_get_udev(udev_device)                 mt_udev_device_get_udev(udev_device)
> +#define udev_device_get_parent(udev_device)               mt_udev_device_get_parent(udev_device)
> +#define udev_device_get_parent_with_subsystem_devtype(udev_device, subsystem, devtype) \
> +	mt_udev_device_get_parent_with_subsystem_devtype(udev_device, subsystem, devtype)
> +#define udev_device_get_devpath(udev_device)              mt_udev_device_get_devpath(udev_device)
> +#define udev_device_get_subsystem(udev_device)            mt_udev_device_get_subsystem(udev_device)
> +#define udev_device_get_devtype(udev_device)              mt_udev_device_get_devtype(udev_device)
> +#define udev_device_get_syspath(udev_device)              mt_udev_device_get_syspath(udev_device)
> +#define udev_device_get_sysname(udev_device)              mt_udev_device_get_sysname(udev_device)
> +#define udev_device_get_is_initialized(udev_device)       mt_udev_device_get_is_initialized(udev_device)
> +#define udev_device_get_property_value(udev_device, key)  mt_udev_device_get_property_value(udev_device, key)
> +#define udev_device_get_devnum(udev_device)               mt_udev_device_get_devnum(udev_device)
> +#define udev_device_get_seqnum(udev_device)               mt_udev_device_get_seqnum(udev_device)
> +#define udev_device_get_driver(udev_device)                       mt_udev_device_get_driver(udev_device)
> +#define udev_device_get_devnode(udev_device)                      mt_udev_device_get_devnode(udev_device)
> +#define udev_device_get_sysattr_value(udev_device, sysattr) \
> +                                                          mt_udev_device_get_sysattr_value(udev_device, sysattr)
> +#define udev_device_set_sysattr_value(udev_device, sysattr, value) \
> +	mt_udev_device_set_sysattr_value(udev_device, sysattr, value)
> +
> +#define udev_device_get_devlinks_list_entry(udev_device)        mt_udev_device_get_devlinks_list_entry(udev_device)
> +#define udev_device_get_properties_list_entry(udev_device)      mt_udev_device_get_properties_list_entry(udev_device)
> +#define udev_device_get_tags_list_entry(udev_device)            mt_udev_device_get_tags_list_entry(udev_device)
> +#define udev_device_get_current_tags_list_entry(udev_device)    mt_udev_device_get_current_tags_list_entry(udev_device)
> +#define udev_device_get_sysattr_list_entry(udev_device)         mt_udev_device_get_sysattr_list_entry(udev_device)
> +
> +#define udev_monitor_new_from_netlink(udev, name)         mt_udev_monitor_new_from_netlink(udev, name)
> +#define udev_monitor_ref(udev_monitor)                    mt_udev_monitor_ref(udev_monitor)
> +#define udev_monitor_unref(udev_monitor)                  mt_udev_monitor_unref(udev_monitor)
> +#define udev_monitor_enable_receiving(udev_monitor)       mt_udev_monitor_enable_receiving(udev_monitor)
> +#define udev_monitor_get_fd(udev_monitor)                 mt_udev_monitor_get_fd(udev_monitor)
> +#define udev_monitor_receive_device(udev_monitor)         mt_udev_monitor_receive_device(udev_monitor)
> +#define udev_monitor_filter_add_match_subsystem_devtype(udev_monitor, subsystem, devtype) \
> +	mt_udev_monitor_filter_add_match_subsystem_devtype(udev_monitor, subsystem, devtype)
> +#define udev_monitor_set_receive_buffer_size(udev_monitor, size) \
> +                                                          mt_udev_monitor_set_receive_buffer_size(udev_monitor, size)
> +
> +#define udev_enumerate_new(udev)                          mt_udev_enumerate_new(udev)
> +#define udev_enumerate_unref(udev_enumerate)              mt_udev_enumerate_unref(udev_enumerate)
> +#define udev_enumerate_add_match_subsystem(udev_enumerate, subsystem) \
> +                                                          mt_udev_enumerate_add_match_subsystem(udev_enumerate, subsystem)
> +#define udev_enumerate_add_nomatch_subsystem(udev_enumerate, subsystem) \
> +                                                          mt_udev_enumerate_add_nomatch_subsystem(udev_enumerate, subsystem)
> +#define udev_enumerate_add_match_sysattr(udev_enumerate, sysattr, value) \
> +                                                          mt_udev_enumerate_add_match_sysattr(udev_enumerate, sysattr, value)
> +#define udev_enumerate_add_nomatch_sysattr(udev_enumerate, sysattr, value) \
> +                                                          mt_udev_enumerate_add_nomatch_sysattr(udev_enumerate, sysattr, value)
> +#define udev_enumerate_add_match_property(udev_enumerate, property, value) \
> +                                                          mt_udev_enumerate_add_match_property(udev_enumerate, property, value)
> +#define udev_enumerate_add_match_tag(udev_enumerate, tag) mt_udev_enumerate_add_match_tag(udev_enumerate, tag)
> +#define udev_enumerate_add_match_parent(udev_enumerate, parent) \
> +                                                          mt_udev_enumerate_add_match_parent(udev_enumerate, parent)
> +#define udev_enumerate_add_match_is_initialized(udev_enumerate) \
> +                                                          mt_udev_enumerate_add_match_is_initialized(udev_enumerate)
> +#define udev_enumerate_add_syspath(udev_enumerate, syspath) \
> +                                                          mt_udev_enumerate_add_syspath(udev_enumerate, syspath)
> +
> +#define udev_enumerate_scan_devices(udev_enumerate)       mt_udev_enumerate_scan_devices(udev_enumerate)
> +#define udev_enumerate_scan_device(udev_enumerate, syspath) \
> +                                                          mt_udev_enumerate_scan_device(udev_enumerate, syspath)
> +#define udev_enumerate_get_list_entry(udev_enumerate)     mt_udev_enumerate_get_list_entry(udev_enumerate)
> +
> +#endif
> -- 
> 2.52.0

