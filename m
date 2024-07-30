Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B0D192B80
	for <dm-devel@lists.linux.dev>; Tue, 30 Jul 2024 07:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722325895; cv=none; b=d0czUS5n71BOE9S3dFWh0BKMm4H+MnN/qbnkRxxAkQvJx3QHruFidsIpmRnVcxKoZOeeRieqr7dxmM8U1UYBbDD8QKdcV8xbzClStyZ65e88mkkS56gab45q418stv/PTOR+VpY5yKVVmFjjBmqSlSh5aaDEwdPwszaJ0R7pKOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722325895; c=relaxed/simple;
	bh=chJnbB32zvpzCYU7ijfQd5+WAcfrUM0IsaJez8gX0Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q6JtY4Fm0EqYbOTKVY5BF0vTqM826iSF3H7feg8PzudkaFUeIhTDGszXhXe3vOuRXEokvca4occNbFweNOGEb4caAp7doIVX7hvzd3s/cVC48zXrPoI6tpJgAdvQF9Ot6UB3RdupwP1GkIxUXKLUqE3Y7QgOBZ/+0rhumBfaw54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CqRIquU/; arc=none smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CqRIquU/"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1722325892; x=1753861892;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=chJnbB32zvpzCYU7ijfQd5+WAcfrUM0IsaJez8gX0Ts=;
  b=CqRIquU/oLLHlOvLr77GVn1Gl+U/uTWeO5QsMusap4SkaouurMAl4tEI
   +2s5CGA1izf0AO2SZWkVf9AXyXFVHgDuYfL9KMJaEdnQyF0Iao6EEwdJW
   uQkRROgiA/+Af3cPff6k0AQ5AqOj5PE80Ol/F0crulfEfEGgnyRrODpSf
   PhFXSBOZO20p7lTrylRlWpuzx4obXwOkAaszxGO8dYf+Qt/+oyJ8I/IfN
   5Dgs/oq1T079KxUl1jc6+MvqRoj33DL8rs2I+RpaXLLwa47iE3YoZOEXL
   2hfDesHoqBAv3zcSfns9JP6GtfZpaF+emMYd9VW1a8yrSgd8DfqNBCddC
   w==;
X-CSE-ConnectionGUID: bqPha4jPRiygKkHh5KTNgA==
X-CSE-MsgGUID: 4mz7zKXDQhOl5TJxcYpwFA==
X-IronPort-AV: E=Sophos;i="6.09,248,1716220800"; 
   d="scan'208";a="23050863"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jul 2024 15:51:30 +0800
IronPort-SDR: 66a88ee6_u/r7jbZ7Oz2ho+ogO5xB7z6SNEkqmo/j9nZHtZEze4bgzYW
 ncEkg9mZc1p25eW+tRZRUF1rlURu0LMyMtWLlBg==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 29 Jul 2024 23:57:42 -0700
WDCIronportException: Internal
Received: from unknown (HELO shindev.ssa.fujisawa.hgst.com) ([10.149.66.30])
  by uls-op-cesaip01.wdc.com with ESMTP; 30 Jul 2024 00:51:30 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests] zbd/011: add test for DM resource limits stacking
Date: Tue, 30 Jul 2024 16:51:29 +0900
Message-ID: <20240730075129.427245-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the kernel commit 73a74af0c72b ("dm: Improve zone resource limits
handling"), zone resource limits (max open zones and max active zones)
are propagated from target zoned devices to mapped devices. As the
kernel commit message describes, the resource limit propagation shall
follow the two rules below based on the number of sequential zones
mapped by the targets:

1) For a target mapping an entire zoned block device, the limits for the
   target are set to the limits of the device.
2) For a target partially mapping a zoned block device, the number of
   mapped sequential zones is used to determine the limits: if the
   target maps more sequential write required zones than the device
   limits, then the limits of the device are used as-is. If the number
   of mapped sequential zones is lower than the limits, then we assume
   that the target has no limits (limits set to 0).

Add a new test case to confirm that the resource limit propagation
follows the rules. Prepare two zoned null_blk devices with different
set ups: number of conventional zones, different max open zones and max
active zones limits. Create variations of DMs using the null_blk devices
and check if the max open zones and the max active zones have expected
values.

Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 tests/zbd/011     | 309 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/zbd/011.out |   2 +
 2 files changed, 311 insertions(+)
 create mode 100755 tests/zbd/011
 create mode 100644 tests/zbd/011.out

diff --git a/tests/zbd/011 b/tests/zbd/011
new file mode 100755
index 0000000..1f667cd
--- /dev/null
+++ b/tests/zbd/011
@@ -0,0 +1,309 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-3.0+
+# Copyright (C) 2024 Western Digital Corporation or its affiliates.
+#
+# Test DM zone resource limits stacking (max open zones and max active zones
+# limits). The limits shall follow these rules:
+# 1) For a target mapping an entire zoned block device, the limits for the
+#    target are set to the limits of the device.
+# 2) For a target partially mapping a zoned block device, the number of
+#    mapped sequential zones is used to determine the limits: if the
+#    target maps more sequential write required zones than the device
+#    limits, then the limits of the device are used as-is. If the number
+#    of mapped sequential zones is lower than the limits, then we assume
+#    that the target has no limits (limits set to 0).
+# As this evaluation is done for each target, the zone resource limits
+# for the mapped device are evaluated as the non-zero minimum of the
+# limits of all the targets.
+
+. tests/zbd/rc
+
+DESCRIPTION="DM zone resource limits stacking"
+QUICK=1
+
+requires() {
+	_have_kver 6 11
+	_have_driver dm-mod
+	_have_driver dm-crypt
+	_have_program dmsetup
+	_have_program cryptsetup
+}
+
+# setup_dm: <map_type> <zoned device> <start zone> [nr zones]>
+# Create a DM device using dm-linear, dm-error or dm-crypt.
+# If <nr_zones> is omitted, then all zones from <start zone> are mapped.
+setup_dm() {
+	local type devpath dname nrz mapzstart mapnrz zsz maplen mapoffset
+	local keyfile="$TMPDIR/keyfile"
+
+	type="$1"
+	devpath="$2"
+	dname="${devpath##*/}"
+	nrz=$(<"/sys/block/${dname}/queue/nr_zones")
+
+	mapzstart="$3"
+	if [ $# == 3 ]; then
+		mapnrz=$((nrz - mapzstart))
+	else
+		mapnrz="$4"
+		if ((mapnrz == 0)) || (( mapzstart + mapnrz > nrz )); then
+			mapnrz=$((nrz - mapzstart))
+		fi
+	fi
+
+	zsz=$(<"/sys/block/${dname}/queue/chunk_sectors")
+	maplen=$((mapnrz * zsz))
+	mapoffset=$((mapzstart * zsz))
+
+	case "$type" in
+	linear|error)
+		if echo "0 ${maplen} ${type} ${devpath} ${mapoffset}" | \
+				dmsetup create "zbd_011-${type}"; then
+			echo "zbd_011-${type}"
+		fi
+		;;
+	crypt)
+		# Generate a key (4096-bits)
+		dd if=/dev/random of="$keyfile" bs=1 count=512 &> /dev/null
+		if cryptsetup open --type plain --cipher null --key-size 512 \
+			      --key-file "$keyfile" --size ${maplen} \
+			      --offset ${mapoffset} "${devpath}" \
+			      "zbd_011-crypt"; then
+			echo "zbd_011-crypt"
+		fi
+		;;
+	esac
+}
+
+# setup_concat: <zoned dev0> <start_zone0> <nr zones0> <zoned dev1> <start_zone1> <nr zones1>
+# Use dm-linear to concatenate 2 sets of zones into a zoned block device.
+# If <nr_zonesX> is 0, then all zones from <start_zoneX> are mapped.
+setup_concat() {
+	local dev0 dname0 nrz0 mapzstart0 mapnrz0
+	local dev1 dname1 nrz1 mapzstart1 mapnrz1
+
+	dev0="$(realpath "$1")"
+	dname0="$(basename "${dev0}")"
+
+	dev1="$(realpath "$4")"
+	dname1="$(basename "${dev1}")"
+
+	nrz0=$(< "/sys/block/${dname0}/queue/nr_zones")
+	mapzstart0=$2
+	if ((mapzstart0 >= nrz0)); then
+		echo "Invalid start zone ${mapzstart0} / ${nrz0}"
+		exit 1
+	fi
+
+	mapnrz0=$3
+	if ((mapnrz0 == 0 || mapzstart0 + mapnrz0 > nrz0)); then
+		mapnrz0=$((nrz0 - mapzstart0))
+	fi
+
+	nrz1=$(< "/sys/block/${dname1}/queue/nr_zones")
+	mapzstart1=$5
+	if ((mapzstart1 >= nrz1)); then
+		echo "Invalid start zone ${mapzstart1} / ${nrz1}"
+		return 1
+	fi
+
+	mapnrz1=$6
+	if ((mapnrz1 == 0 || mapzstart1 + mapnrz1 > nrz1)); then
+		mapnrz1=$((nrz1 - mapzstart1))
+	fi
+
+	zsz=$(< "/sys/block/${dname0}/queue/chunk_sectors")
+	maplen0=$((mapnrz0 * zsz))
+	mapofst0=$((mapzstart0 * zsz))
+	maplen1=$((mapnrz1 * zsz))
+	mapofst1=$((mapzstart1 * zsz))
+
+	# Linear table entries: "start length linear device offset"
+	#  start: starting block in virtual device
+	#  length: length of this segment
+	#  device: block device, referenced by the device name or by major:minor
+	#  offset: starting offset of the mapping on the device
+
+	if echo -e "0 ${maplen0} linear /dev/${dname0} ${mapofst0}\n" \
+		"${maplen0} ${maplen1} linear /dev/${dname1} ${mapofst1}" | \
+			dmsetup create "zbd_011-concat"; then
+		echo "zbd_011-concat"
+	fi
+}
+
+# check_limits: <dev> <zoned model> <number of zones> <max open limit> <max active limit>
+# Check that the zoned model, number of zones and zone resource limits of a DM
+# device match the values of the arguments passed.
+check_limits() {
+	local ret=0
+	local devpath dname sysqueue model nrz moz maz
+
+	devpath=$(realpath "$1")
+	sysqueue="/sys/block/${devpath##*/}/queue"
+	model="$(< "${sysqueue}/zoned")"
+
+	if [[ "$model" != "$2" ]]; then
+		echo "Invalid zoned model: ${model} should be $2"
+		return 1
+	fi
+
+	nrz=$(< "${sysqueue}/nr_zones")
+	if [[ ${nrz} -ne $3 ]]; then
+		echo "Invalid number of zones: ${nrz} should be $3"
+		ret=1
+	fi
+
+	# Non-zoned block devices do not have max_open_zones and
+	# max_active_zones sysfs attributes.
+	[[ "$2" == "none" ]] && return $ret
+
+	moz=$(< "${sysqueue}/max_open_zones")
+	if [[ ${moz} -ne $4 ]]; then
+		echo "Invalid max open zones limit: ${moz} should be $4"
+		ret=1
+	fi
+
+	maz=$(< "${sysqueue}/max_active_zones")
+	if [[ ${maz} -ne $5 ]]; then
+		echo "Invalid max active zones limit: ${maz} should be $5"
+		ret=1
+	fi
+
+	return $ret
+}
+
+declare -a TEST_DESCRIPTIONS
+declare -a SETUP_COMMANDS
+declare -a EXPECTED_LIMITS
+
+# Test 1
+TEST_DESCRIPTIONS+=("Map all zones of the 1st nullb")
+SETUP_COMMANDS+=("setup_dm linear /dev/nullb_zbd_011_1 0")
+EXPECTED_LIMITS+=("host-managed 1152 64 64")
+
+# Test 2
+TEST_DESCRIPTIONS+=("Map all zones of the 2nd nullb")
+SETUP_COMMANDS+=("setup_dm linear /dev/nullb_zbd_011_2 0")
+EXPECTED_LIMITS+=("host-managed 512 48 0")
+
+# Test 3
+TEST_DESCRIPTIONS+=("Map all CNV zones of the 1st nullb")
+SETUP_COMMANDS+=("setup_dm linear /dev/nullb_zbd_011_1 0 128")
+EXPECTED_LIMITS+=("none 0 0 0")
+
+# Test 4
+TEST_DESCRIPTIONS+=("Map all SWR zones of the 1st nullb")
+SETUP_COMMANDS+=("setup_dm linear /dev/nullb_zbd_011_1 128")
+EXPECTED_LIMITS+=("host-managed 1024 64 64")
+
+# Test 5
+TEST_DESCRIPTIONS+=("Map 32 SWR zones of the 1st nullb")
+SETUP_COMMANDS+=("setup_dm linear /dev/nullb_zbd_011_1 128 32")
+EXPECTED_LIMITS+=("host-managed 32 0 0")
+
+# Test 6
+TEST_DESCRIPTIONS+=("Map 64 SWR zones of the 1st nullb")
+SETUP_COMMANDS+=("setup_dm linear /dev/nullb_zbd_011_1 128 64")
+EXPECTED_LIMITS+=("host-managed 64 0 0")
+
+# Test 7
+TEST_DESCRIPTIONS+=("Map 128 SWR zones of the 1st nullb")
+SETUP_COMMANDS+=("setup_dm linear /dev/nullb_zbd_011_1 128 128")
+EXPECTED_LIMITS+=("host-managed 128 64 64")
+
+# Test 8
+TEST_DESCRIPTIONS+=("Concatenate all zones of the 1st and 2nd nullb")
+SETUP_COMMANDS+=("setup_concat /dev/nullb_zbd_011_1 0 0 /dev/nullb_zbd_011_2 0 0")
+EXPECTED_LIMITS+=("host-managed 1664 48 64")
+
+# Test 9
+TEST_DESCRIPTIONS+=("Map 32 CNV zones of the 1st nullb and all SWR zones of the 2nd nullb")
+SETUP_COMMANDS+=("setup_concat /dev/nullb_zbd_011_1 0 32 /dev/nullb_zbd_011_2 0 0")
+EXPECTED_LIMITS+=("host-managed 544 48 0")
+
+# Test 10
+TEST_DESCRIPTIONS+=("Map all SWR zones of the 1st nullb and all SWR zones of the 2nd nullb")
+SETUP_COMMANDS+=("setup_concat /dev/nullb_zbd_011_1 128 0 /dev/nullb_zbd_011_2 0 0")
+EXPECTED_LIMITS+=("host-managed 1536 48 64")
+
+# Test 11
+TEST_DESCRIPTIONS+=("Map 32 SWR zones of the 1st nullb and all SWR zones of the 2nd nullb")
+SETUP_COMMANDS+=("setup_concat /dev/nullb_zbd_011_1 128 32 /dev/nullb_zbd_011_2 0 0")
+EXPECTED_LIMITS+=("host-managed 544 48 0")
+
+# Test 12
+TEST_DESCRIPTIONS+=("Map 128 SWR zones of the 1st nullb and 16 SWR zones of the 2nd nullb")
+SETUP_COMMANDS+=("setup_concat /dev/nullb_zbd_011_1 128 128 /dev/nullb_zbd_011_2 0 16")
+EXPECTED_LIMITS+=("host-managed 144 64 64")
+
+# Test 13
+TEST_DESCRIPTIONS+=("Map 32 SWR zones of the 1st nullb and 16 SWR zones of the 2nd nullb")
+SETUP_COMMANDS+=("setup_concat /dev/nullb_zbd_011_1 128 32 /dev/nullb_zbd_011_2 0 16")
+EXPECTED_LIMITS+=("host-managed 48 0 0")
+
+# Test 14
+TEST_DESCRIPTIONS+=("Map 32 SWR zones of the 1st nullb and 48 SWR zones of the 2nd nullb")
+SETUP_COMMANDS+=("setup_concat /dev/nullb_zbd_011_1 128 32 /dev/nullb_zbd_011_2 0 48")
+EXPECTED_LIMITS+=("host-managed 80 0 0")
+
+# Test 15
+TEST_DESCRIPTIONS+=("Map 32 SWR zones of the 1st nullb and 64 SWR zones of the 2nd nullb")
+SETUP_COMMANDS+=("setup_concat /dev/nullb_zbd_011_1 128 32 /dev/nullb_zbd_011_2 0 64")
+EXPECTED_LIMITS+=("host-managed 96 48 0")
+
+# Test 16
+TEST_DESCRIPTIONS+=("Insert dm-error on the 1st nullb")
+SETUP_COMMANDS+=("setup_dm error /dev/nullb_zbd_011_1 0")
+EXPECTED_LIMITS+=("host-managed 1152 64 64")
+
+# Test 17
+TEST_DESCRIPTIONS+=("Map all zones of the 1st nullb with dm-crypt")
+SETUP_COMMANDS+=("setup_dm crypt /dev/nullb_zbd_011_1 0")
+EXPECTED_LIMITS+=("host-managed 1152 64 64")
+
+# Test 18
+TEST_DESCRIPTIONS+=("Map all CNV zones of the 1st nullb with dm-crypt")
+SETUP_COMMANDS+=("setup_dm crypt /dev/nullb_zbd_011_1 0 128")
+EXPECTED_LIMITS+=("none 0 0 0")
+
+# Test 19
+TEST_DESCRIPTIONS+=("Map all CNV zones and 128 SWR zones of the 1st nullb with dm-crypt")
+SETUP_COMMANDS+=("setup_dm crypt /dev/nullb_zbd_011_1 0 256")
+EXPECTED_LIMITS+=("host-managed 256 64 64")
+
+# Test 20
+TEST_DESCRIPTIONS+=("Map 64 SWR zones of the 1st nullb with dm-crypt")
+SETUP_COMMANDS+=("setup_dm crypt /dev/nullb_zbd_011_1 128 64")
+EXPECTED_LIMITS+=("host-managed 64 0 0")
+
+# Test 21
+TEST_DESCRIPTIONS+=("Map all SWR zones of the 2nd nullb with dm-crypt")
+SETUP_COMMANDS+=("setup_dm crypt /dev/nullb_zbd_011_2 0")
+EXPECTED_LIMITS+=("host-managed 512 48 0")
+
+test() {
+	local i dm_name check_cmd
+
+	echo "Running ${TEST_NAME}"
+
+	_configure_null_blk nullb_zbd_011_1 size=2304 zoned=1 \
+			    zone_size=2 zone_nr_conv=128 \
+			    zone_max_open=64 zone_max_active=64 power=1
+	_configure_null_blk nullb_zbd_011_2 size=1024 zoned=1 \
+			    zone_size=2 zone_nr_conv=0 \
+			    zone_max_open=48 zone_max_active=0 power=1
+
+	for ((i = 0; i < ${#TEST_DESCRIPTIONS[@]}; i++)); do
+		dm_name=$(eval "${SETUP_COMMANDS[i]}")
+		check_cmd="check_limits /dev/mapper/$dm_name"
+		check_cmd+=" ${EXPECTED_LIMITS[i]}"
+		if ! eval "$check_cmd"; then
+			echo "Test $((i + 1)) failed: ${TEST_DESCRIPTIONS[i]}"
+		fi
+		dmsetup remove "$dm_name"
+	done
+
+	_exit_null_blk
+
+	echo "Test complete"
+}
diff --git a/tests/zbd/011.out b/tests/zbd/011.out
new file mode 100644
index 0000000..aec7f70
--- /dev/null
+++ b/tests/zbd/011.out
@@ -0,0 +1,2 @@
+Running zbd/011
+Test complete
-- 
2.45.2

