Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEBBDC4332F
	for <dm-devel@archiver.kernel.org>; Tue, 29 Mar 2022 05:32:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-FDrxBL3oP0GrlIy4zHNeeA-1; Tue, 29 Mar 2022 01:32:07 -0400
X-MC-Unique: FDrxBL3oP0GrlIy4zHNeeA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E0361C06929;
	Tue, 29 Mar 2022 05:32:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2400E401E58;
	Tue, 29 Mar 2022 05:32:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7F34F1940355;
	Tue, 29 Mar 2022 05:32:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A9D521947BBE
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Mar 2022 11:18:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9E8F5C15D57; Mon, 28 Mar 2022 11:18:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ADAFC15D4F
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 11:18:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DD049219A6
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 11:18:46 +0000 (UTC)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com
 [209.85.167.41]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-YmFeVCezMUGy6j2KwPiI0w-1; Mon, 28 Mar 2022 07:18:44 -0400
X-MC-Unique: YmFeVCezMUGy6j2KwPiI0w-1
Received: by mail-lf1-f41.google.com with SMTP id k21so24116752lfe.4
 for <dm-devel@redhat.com>; Mon, 28 Mar 2022 04:18:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
 :references:user-agent:mime-version:content-transfer-encoding;
 bh=N926ipqlEwj4JO1xTcsrXgCa3AA/3fWt5Bm+xv75a5E=;
 b=JT84F5wMcVcboXPLR+lIAItmyjVOGu0WrKsdZ0k2Sitogc6mU5XmbnYPvCtlChlF8U
 clPSf+9/e/vrAauH6Ym6FPr+q5LO6l21J/ZbWi3X7I2BFtkIUy4HoXsgd05/TX3YrT4m
 rlmtvZsHeufsrqLBONXIvGnQyGqmM9hJlMR+LXTukOfu7BczM9TvQ6o+2HuITEZpoTeA
 cmRMLhu7fm0anmuSGDhxifT2zU2uoCWM68dsX1ZobWQjBGTmVMXhodufgiEADVywP6d0
 nnOT+VsscWJpgNp0yAERbUmolcq3HdHk+EMleHHL+2oNM+BYTefOUvnjGyFqplqGLDZa
 H6+g==
X-Gm-Message-State: AOAM531mCxoc97kYo7Rbl8IPuQLC3DjZF8Hb5/jRss0X+JksWg79cCL7
 6vepzO2VkNI60RWs46dJVSNoMgJAbrVqKj7O
X-Google-Smtp-Source: ABdhPJwe/gX2NWrPoEuwfjHT3h0n/GqZ0JM31cCteh0vGnsgz/4AYMDMtb0HtiAGvAasyUXkJKGZ5w==
X-Received: by 2002:ac2:43bb:0:b0:44a:1ee6:8c12 with SMTP id
 t27-20020ac243bb000000b0044a1ee68c12mr19628435lfl.683.1648466323220; 
 Mon, 28 Mar 2022 04:18:43 -0700 (PDT)
Received: from [127.0.1.1] ([2.92.192.17]) by smtp.gmail.com with ESMTPSA id
 t19-20020a199113000000b0044a2d7a1f4asm1601632lfd.206.2022.03.28.04.18.42
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 28 Mar 2022 04:18:42 -0700 (PDT)
From: Kirill Tkhai <kirill.tkhai@openvz.org>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, 
 linux-kernel@vger.kernel.org, khorenko@virtuozzo.com,
 kirill.tkhai@openvz.org
Date: Mon, 28 Mar 2022 14:18:41 +0300
Message-ID: <164846632180.251310.3616379476259718920.stgit@pro>
In-Reply-To: <164846619932.251310.3668540533992131988.stgit@pro>
References: <164846619932.251310.3668540533992131988.stgit@pro>
User-Agent: StGit/1.5
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Tue, 29 Mar 2022 05:32:01 +0000
Subject: [dm-devel] [PATCH 4/4] dm-qcow2: Add helper for working with
 dm-qcow2 devices
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This scripts allows to create and remove dm-qcow2 device,
create internal snapshot, resize virtual device size,
or check image consistency on live device.

Signed-off-by: Kirill Tkhai <kirill.tkhai@openvz.org>
---
 scripts/qcow2-dm.sh |  249 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 249 insertions(+)
 create mode 100755 scripts/qcow2-dm.sh

diff --git a/scripts/qcow2-dm.sh b/scripts/qcow2-dm.sh
new file mode 100755
index 000000000000..7d9bda44c1d6
--- /dev/null
+++ b/scripts/qcow2-dm.sh
@@ -0,0 +1,249 @@
+#!/bin/bash
+#
+# This requires parameter dm_qcow2.kernel_sets_dirty_bit=y
+
+usage () {
+    cat <<EOF
+Usage:
+	$prog_name create <file.qcow2> <dev_name>
+	$prog_name remove <file.qcow2>
+	$prog_name check [qemu-img check optional args] <file.qcow2>
+	$prog_name snapshot [qemu-img snapshot optional args] <file.qcow2>
+	$prog_name resize [qemu-img resize optional args] <file.qcow2> [+ | -]size
+EOF
+}
+
+get_img_size () {
+	sz=`qemu-img info -f qcow2 $1 | grep "virtual size" | sed 's/.*(\(.*\) bytes)/\1/'`
+	echo $sz
+}
+
+get_nr_imgs () {
+	nr=`echo $1 | sed "s/.*qcow2 \(\w\) .*$/\1/"`
+	echo $nr
+}
+
+get_dev_of_image () {
+	abs_path=$1
+
+	while read line; do
+		dev=`echo $line | sed "s/:.*//"`
+		nr_imgs=$(get_nr_imgs "$line")
+		top_img_id=$((nr_imgs - 1))
+
+		top_img_path=`dmsetup message $dev 0 get_img_name $top_img_id`
+		if [ -z "$top_img_path" ]; then
+			echo >&2 "Error during search of device"; exit 1;
+			return 1
+		fi
+
+		if [ "$abs_path" != "$top_img_path" ]; then
+			continue
+		fi
+
+		echo $dev
+		return 0
+
+	done < <(LANG=C dmsetup table --target=qcow2 | grep -v "No devices found")
+
+	return 0
+}
+
+create () {
+	if [ "$#" -ne 2 ]; then
+		echo >&2 "Wrong number of arguments."; usage; exit 1;
+	fi
+
+	file=$1
+	dev=$2
+	files=()
+	fds=""
+
+	qemu-img check $file || exit 1
+
+	disk_sz=$(get_img_size "$file")
+	echo disk_sz=$disk_sz
+	if [ -z "$disk_sz" ]; then
+		echo "Can't get disk size."; exit 1;
+	fi
+
+	while :; do
+		if [ ! -f "$file" ]; then
+			echo "$file does not exist."; exit 1;
+		fi
+
+		files+=("$file")
+
+		exec {fd}<>$file || exit 1
+		flock -x $fd || exit 1
+		fds="$fd $fds"
+
+		file=`qemu-img info $file | grep "backing file:" | sed "s/backing file: //"`
+		if [ -z "$file" ]; then
+			break
+		fi
+	done
+
+	echo "Create device [$dev] of size $disk_sz from [${files[*]}]."
+	dmsetup create $dev --table "0 $((disk_sz / 512)) qcow2 ${fds}"
+}
+
+reload_device () {
+	disk_sz=$(get_img_size "$abs_path")
+	if [ -z "$disk_sz" ]; then
+		echo "Can't get disk size."; return;
+	fi
+
+	line=`dmsetup table $dev`
+	nr_imgs=$(get_nr_imgs "$line")
+	top_img_id=$((nr_imgs - 1))
+	fds=""
+
+	for id in `seq 0 $top_img_id`;
+	do
+		file=`dmsetup message $dev 0 get_img_name $id`
+		if [ -z "$file" ]; then
+			echo "Can't get image file."; return;
+		fi
+		exec {fd}<>$file || exit 1
+
+		fds="$fds $fd"
+	done
+
+	echo "Reloading $dev."
+	dmsetup reload $dev --table "0 $((disk_sz / 512)) qcow2 ${fds}"
+}
+
+remove () {
+	if [ "$#" -ne 1 ]; then
+		echo >&2 "Wrong number of arguments."; usage; exit 1;
+	fi
+	user_path=$1
+	abs_path=`realpath $user_path`
+
+	dev=$(get_dev_of_image "$abs_path")
+	if [ -z "$dev" ]; then
+		echo >&2 "Can't find device with [$user_path] top image."; exit 1
+	fi
+
+	echo "Removing device [$dev]."
+	dmsetup remove $dev
+	ret=$?
+
+	if [ $ret -eq 0 ]; then
+		#Sanity check
+		echo "Checking [$abs_path]."
+		qemu-img check $abs_path
+	fi
+	exit $ret
+}
+
+qemu_img () {
+	wants_reload=0
+	if [ $1 == "--wants_reload" ]; then
+		wants_reload=1
+		shift
+	fi
+
+	if [ "$#" -lt 3 ]; then
+		echo >&2 "Wrong number of arguments."; usage; exit 1;
+	fi
+
+	user_path=$1
+	cmd=$2
+	abs_path=`realpath $user_path`
+	qemu_img_args=${@: 2}
+
+	dev=$(get_dev_of_image "$abs_path")
+	if [ -z "$dev" ]; then
+		echo >&2 "Can't find device by [$user_path]."; return 1
+	fi
+
+	echo "Suspending $dev."
+	dmsetup suspend $dev || exit 1
+
+	if [ "$cmd" != "check" ]; then
+		echo "Checking $abs_path"
+		qemu-img check $abs_path
+		ret=$?
+		if [ $ret -ne 0 ]; then
+			echo "Resuming $dev."
+			dmsetup resume $dev
+			exit 1
+		fi
+	fi
+
+	echo "===== Call:  qemu-img $qemu_img_args. ====="
+	qemu-img $qemu_img_args
+	ret=$?
+	if [ $ret -ne 0 ]; then
+		echo >&2 "Failed during qemu-img call."
+	fi
+	echo "===== End of qemu-img $qemu_img_args. ====="
+
+	if [ $wants_reload -ne 0 ]; then
+		reload_device $dev $abs_path
+	fi
+
+	echo "Resuming $dev."
+	dmsetup resume $dev || exit 1
+	if [ $? -ne 0 ]; then
+		ret=$?
+	fi
+
+	return $ret
+}
+
+check () {
+	user_path=${@: -1}
+	qemu_img_args=$@
+
+	qemu_img $user_path check $qemu_img_args
+	return $?
+}
+
+snapshot () {
+	user_path=${@: -1}
+	qemu_img_args=$@
+
+	qemu_img $user_path snapshot $qemu_img_args
+	return $?
+}
+
+resize () {
+	user_path=${@:(-2):1}
+	qemu_img_args=$@
+
+	qemu_img --wants_reload $user_path resize $qemu_img_args
+	return $?
+}
+
+prog_name=$(basename $0)
+
+case $1 in
+	"create")
+		shift
+		create "$@"
+		exit 0
+		;;
+	"remove")
+		shift
+		remove "$@"
+		;;
+	"check")
+		shift
+		check "$@"
+		;;
+	"snapshot")
+		shift
+		snapshot "$@"
+		;;
+	"resize")
+		shift
+		resize "$@"
+		;;
+	*)
+		usage
+		exit 1
+	        ;;
+esac


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

